"""브라우저 없이 HTTP로 수집(reviews.py의 빠른 버전). 검색 목록과 첫 10개 리뷰는 페이지 HTML의 Apollo JSON에 들어 있다.
사용: python fast.py 파일.csv --region 강남구 --type 일반미용업 --workers 8 --resume --out gangnam
출력 형식은 reviews.py와 같다. 주의: Accept-Language: ko 헤더가 없으면 데이터 없는 빈 페이지가 온다.
"""
import argparse, csv, json, os, random, re, time
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timedelta
import requests
from reviews import ITEM, EXCL_CAT, load_rows, road_key, stem, unesc

H = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36",
     "Accept-Language": "ko-KR,ko;q=0.9"}


def get(url, **kw):
    for i in range(4):
        try:
            r = requests.get(url, headers=H, timeout=20, **kw)
            r.encoding = "utf-8"  # 헤더에 charset이 없어 requests가 latin-1로 추측함
            if r.status_code == 200 and len(r.text) > 50000:  # 빈 페이지/차단 페이지는 작다
                return r.text
        except requests.RequestException:
            pass
        time.sleep(2 ** i + random.random())  # shortcut: 4번 실패하면 포기(None), 차단 급증 시 사람이 중단
    return None


def find_place(row):
    key = road_key(row["도로명주소"])
    dong = re.search(r"\((.*?)\)", row["도로명주소"])
    dong = dong.group(1).split(",")[0].strip() if dong else ""
    gu, name, cand, fail = row["도로명주소"].split()[1], row["사업장명"], None, False
    for q in (f"{gu} {name}", f"{dong or gu} {name.replace(' ', '')}"):
        h = get("https://pcmap.place.naver.com/place/list", params={"query": q})
        if h is None:
            fail = True; continue
        for pid, n, cat, addr, common in ITEM.findall(h):
            addr, n = unesc(addr), unesc(n)
            if re.search(re.escape(key) + r"(?!\d)", addr):
                return (pid, n, addr, "확정", unesc(cat)), False
            if not cand and dong and dong in unesc(common) and len(stem(name)) >= 2 and stem(n) == stem(name):
                cand = (pid, n, addr, "후보", unesc(cat))
    return cand, fail and not cand


def read_reviews(pid, n):
    h = get(f"https://pcmap.place.naver.com/place/{pid}/review/visitor", params={"reviewSort": "recent"})
    if h is None:
        return None
    st, _ = json.JSONDecoder().raw_decode(h[re.search(r"__APOLLO_STATE__\s*=\s*", h).end():])
    out, seen = [], set()
    for k, v in st.items():
        if not k.startswith("VisitorReview:") or v.get("id") in seen:
            continue
        seen.add(v["id"])
        au = st.get(v["author"]["__ref"], {}) if v.get("author") else {}
        t = v.get("representativeVisitDateTime")
        d = (datetime.fromisoformat(t.replace("Z", "+00:00")) + timedelta(hours=9)).strftime("%Y-%m-%d") if t else v.get("visited", "")
        out.append({"nickname": au.get("nickname", ""), "date": d, "visit": f"{v['visitCount']}번째 방문" if v.get("visitCount") else "",
                    "content": (v.get("body") or "").strip()})
    return out[:n]


def work(r, n):
    time.sleep(random.uniform(0, 1))
    hit, fail = find_place(r)
    if hit and EXCL_CAT.search(hit[4]):
        hit = hit[:3] + ("제외(카테고리)", hit[4])
    revs = read_reviews(hit[0], n) if hit and hit[3] == "확정" else []
    return r, hit, revs, fail or revs is None  # 네트워크 실패는 shops에 기록하지 않아 --resume 때 재시도


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("csv"); ap.add_argument("--region", default="종로구"); ap.add_argument("--type", default="")
    ap.add_argument("--limit", type=int, default=0); ap.add_argument("--max-reviews", type=int, default=10)
    ap.add_argument("--workers", type=int, default=8); ap.add_argument("--out", default="out")
    ap.add_argument("--resume", action="store_true")
    a = ap.parse_args()
    rows = load_rows(a.csv, a.region, a.type)
    if a.limit:
        rows = rows[: a.limit]
    sp = f"{a.out}_shops.csv"
    resume = a.resume and os.path.exists(sp)
    if resume:
        done = {r["관리번호"] for r in csv.DictReader(open(sp, encoding="utf-8-sig", newline=""))}
        rows = [r for r in rows if r["관리번호"] not in done]
    print(f"대상 {len(rows)}곳")
    mode = "a" if resume else "w"
    with open(f"{a.out}_reviews.csv", mode, encoding="utf-8-sig", newline="") as fr, open(sp, mode, encoding="utf-8-sig", newline="") as fs, \
            ThreadPoolExecutor(a.workers) as ex:
        wr, ws = csv.writer(fr), csv.writer(fs)
        if not resume:
            wr.writerow(["관리번호", "사업장명", "place_id", "nickname", "date", "visit", "content"])
            ws.writerow(["관리번호", "사업장명", "도로명주소", "place_id", "네이버주소", "match_level", "naver_category", "리뷰수"])
        t0, nfail = time.time(), 0
        for i, f in enumerate(as_completed([ex.submit(work, r, a.max_reviews) for r in rows]), 1):
            try:
                r, hit, revs, fail = f.result()
            except Exception as e:
                print("  오류:", e); continue
            if fail:
                nfail += 1; print("  네트워크 실패(기록 안 함):", r["사업장명"]); continue
            for v in revs:
                wr.writerow([r["관리번호"], r["사업장명"], hit[0], v["nickname"], v["date"], v["visit"], v["content"]])
            ws.writerow([r["관리번호"], r["사업장명"], r["도로명주소"], hit[0] if hit else "", hit[2] if hit else "", hit[3] if hit else "", hit[4] if hit else "", len(revs)])
            fr.flush(); fs.flush()
            if i % 20 == 0:
                print(f"[{i}/{len(rows)}] {time.time() - t0:.0f}s 실패 {nfail}")


if __name__ == "__main__":
    main()
