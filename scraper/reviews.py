"""인허가 CSV(영업/정상) -> 네이버 지도 장소 매칭 -> 방문자 리뷰 수집.

사용: python reviews.py 파일.csv --region 종로구 --limit 5 --max-reviews 30
의존: pip install playwright && playwright install chromium
"""
import argparse, csv, json, random, re, time
from playwright.sync_api import sync_playwright

ITEM = re.compile(r'"__typename":"PlaceListBusinessesItem","id":"(\d+)","name":"(.*?)",.*?"fullAddress":"(.*?)","commonAddress":"(.*?)"')


MORE_JS = """() => {
  const b = [...document.querySelectorAll('a')].filter(a => a.innerText.trim() === '더보기' && !a.closest('li')).pop();
  if (b) b.click(); return !!b; }"""

PARSE_JS = """n => [...document.querySelectorAll('li[class*=EjjAW]')].slice(0, n).map(li => {
  const q = s => li.querySelector(s);
  const d = li.querySelectorAll('span.pui__gfuUIT > span.pui__blind');
  return {nickname: q('span.pui__uslU0d')?.innerText.trim() || '',
          date: [...d].map(x => x.innerText).find(t => /\\d{4}년/.test(t)) || q('time')?.innerText || '',
          visit: [...li.querySelectorAll('span.pui__gfuUIT')].map(x => x.innerText).find(t => /번째 방문/.test(t)) || '',
          content: q('div.pui__vn15t2')?.innerText.trim() || ''};
}) """


def unesc(s):
    return json.loads(f'"{s}"')


def road_key(addr):
    # "서울특별시 종로구 세종대로23길 47, 101동 (당주동)" -> "세종대로23길 47"
    a = re.sub(r"\(.*?\)", "", addr).split(",")[0].strip()
    return re.sub(r"^\S+\s+\S+\s+", "", a)


def stem(name):
    # "신세계 이발관" -> "신세계": 업종 접미어와 공백을 뺀 이름
    return re.sub(r"이발관|이발소|이용원|이용실|이발|바버샵|\s", "", name)


def find_place(pg, row):
    """(place_id, 이름, 주소, 매칭수준) 또는 None. 확정=도로명 일치, 후보=같은 동+같은 이름 줄기(사람이 확인)."""
    key = road_key(row["도로명주소"])
    dong = re.search(r"\((.*?)\)", row["도로명주소"])
    dong = dong.group(1) if dong else ""
    gu = row["도로명주소"].split()[1]
    name = row["사업장명"]
    cand = None
    for q in (f"{gu} {name}", f"{dong or gu} {name.replace(' ', '')}"):
        pg.goto(f"https://map.naver.com/p/search/{q}", wait_until="domcontentloaded")
        try:
            pg.wait_for_selector("iframe#searchIframe", timeout=15000)
        except Exception:
            continue
        # 검색 결과(빈 결과 포함)가 로드됐다는 표시인 placeList가 나올 때까지 최대 ~15초 대기
        for _ in range(10):
            pg.wait_for_timeout(1500)
            html = pg.frame(name="searchIframe").content()
            if "placeList(" in html:
                break
        for pid, n, addr, common in ITEM.findall(html):
            addr, n = unesc(addr), unesc(n)
            if re.search(re.escape(key) + r"(?!\d)", addr):
                return pid, n, addr, "확정"
            # shortcut: 동·이름 줄기가 같아도 동명 가게일 수 있어 자동 채택하지 않음, 사람이 확인
            if not cand and dong and dong in unesc(common) and len(stem(name)) >= 2 and stem(n) == stem(name):
                cand = (pid, n, addr, "후보")
    return cand


def read_reviews(pg, pid, max_reviews):
    pg.goto(f"https://pcmap.place.naver.com/place/{pid}/review/visitor?reviewSort=recent", wait_until="domcontentloaded")
    li = "li[class*=EjjAW]"
    try:
        pg.wait_for_selector(li, timeout=12000)
    except Exception:
        return []  # 리뷰 없음 또는 로딩 실패
    while pg.locator(li).count() < max_reviews:
        before = pg.locator(li).count()
        # 리스트 하단의 "더보기"만 클릭(리뷰 안 접힘 버튼, "펼쳐서 더보기"는 제외)
        if not pg.evaluate(MORE_JS):
            break
        try:
            pg.wait_for_function(f"document.querySelectorAll('{li}').length > {before}", timeout=8000)
        except Exception:
            break  # 더 이상 안 늘어남(끝, 또는 로딩 정체)
    # 리뷰 본문 접힘 해제
    pg.evaluate("document.querySelectorAll('li[class*=EjjAW] div.pui__vn15t2 a').forEach(a=>a.click())")
    out = pg.evaluate(PARSE_JS, max_reviews)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("csv")
    ap.add_argument("--region", default="종로구")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--max-reviews", type=int, default=30)
    ap.add_argument("--out", default="out")
    ap.add_argument("--chrome", default=None, help="chrome 실행 파일 경로(생략하면 playwright 기본 브라우저)")
    a = ap.parse_args()

    rows = [r for r in csv.DictReader(open(a.csv, encoding="cp949", newline=""))
            if r["영업상태명"] == "영업/정상" and a.region in r["도로명주소"]]
    if a.limit:
        rows = rows[: a.limit]
    print(f"대상 {len(rows)}곳")

    with sync_playwright() as p, open(f"{a.out}_reviews.csv", "w", encoding="utf-8-sig", newline="") as fr, \
            open(f"{a.out}_shops.csv", "w", encoding="utf-8-sig", newline="") as fs:
        b = p.chromium.launch(executable_path=a.chrome, args=["--no-sandbox"])
        pg = b.new_page(locale="ko-KR")
        wr = csv.writer(fr); wr.writerow(["관리번호", "사업장명", "place_id", "nickname", "date", "visit", "content"])
        ws = csv.writer(fs); ws.writerow(["관리번호", "사업장명", "도로명주소", "place_id", "네이버주소", "match_level", "리뷰수"])
        for i, r in enumerate(rows, 1):
            try:
                hit = find_place(pg, r)
                revs = read_reviews(pg, hit[0], a.max_reviews) if hit and hit[3] == "확정" else []  # 후보는 리뷰 미수집
            except Exception as e:  # 한 곳 실패가 전체를 멈추지 않게
                print("  오류:", r["사업장명"], e); hit, revs = None, []
            for v in revs:
                wr.writerow([r["관리번호"], r["사업장명"], hit[0], v["nickname"], v["date"], v["visit"], v["content"]])
            ws.writerow([r["관리번호"], r["사업장명"], r["도로명주소"], hit[0] if hit else "", hit[2] if hit else "", hit[3] if hit else "", len(revs)])
            fr.flush(); fs.flush()
            print(f"[{i}/{len(rows)}] {r['사업장명']} -> {hit[3] + ' ' + hit[0] if hit else '매칭 실패'}, 리뷰 {len(revs)}")
            time.sleep(random.uniform(2, 4))
        b.close()


if __name__ == "__main__":
    main()
