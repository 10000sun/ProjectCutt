"""인허가 CSV(영업/정상) -> 네이버 지도 장소 매칭 -> 방문자 리뷰 수집.

사용: python reviews.py 파일.csv --region 종로구 --limit 5 --max-reviews 30
의존: pip install playwright && playwright install chromium
"""
import argparse, csv, json, os, random, re, time
from playwright.sync_api import sync_playwright

ITEM = re.compile(r'"__typename":"PlaceListBusinessesItem","id":"(\d+)","name":"(.*?)","normalizedName":".*?","category":"(.*?)",.*?"fullAddress":"(.*?)","commonAddress":"(.*?)"')


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

# 미용실이 아닌 곳 제외(염색 전문점은 데이터에 구분이 없어 이름 키워드로 거름, 오탐 가능)
EXCL_NAME = re.compile(r"피부|스킨|에스테|두피|탈모|왁싱|속눈썹|눈썹|네일|메이크업|반영구|타투|염색|헤나|컬러|칼라|color", re.I)
EXCL_CAT = re.compile(r"피부|두피|네일|왁싱|속눈썹|반영구|메이크업|마사지|에스테|타투")


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
    """(place_id, 이름, 주소, 매칭수준, 네이버카테고리) 또는 None. 확정=도로명 일치, 후보=같은 동+같은 이름 줄기(사람이 확인)."""
    key = road_key(row["도로명주소"])
    dong = re.search(r"\((.*?)\)", row["도로명주소"])
    dong = dong.group(1).split(",")[0].strip() if dong else ""  # "(명륜2가, 아파트명)" -> "명륜2가"
    gu = row["도로명주소"].split()[1]
    name = row["사업장명"]
    cand = None
    for q in (f"{gu} {name}", f"{dong or gu} {name.replace(' ', '')}"):
        pg.goto(f"https://map.naver.com/p/search/{q}", wait_until="domcontentloaded")
        try:
            pg.wait_for_selector("iframe#searchIframe", timeout=15000)
        except Exception:
            continue
        # 결과 항목이 나올 때까지 최대 ~15초 대기(빈 결과와 로딩 중을 구분할 수 없어 끝까지 기다림)
        items = []
        for _ in range(10):
            pg.wait_for_timeout(1500)
            f = pg.frame(name="searchIframe")  # 로딩 중 iframe이 교체되면 None
            items = ITEM.findall(f.content()) if f else []
            if items:
                break
        for pid, n, cat, addr, common in items:
            addr, n = unesc(addr), unesc(n)
            if re.search(re.escape(key) + r"(?!\d)", addr):
                return pid, n, addr, "확정", unesc(cat)
            # shortcut: 동·이름 줄기가 같아도 동명 가게일 수 있어 자동 채택하지 않음, 사람이 확인
            if not cand and dong and dong in unesc(common) and len(stem(name)) >= 2 and stem(n) == stem(name):
                cand = (pid, n, addr, "후보", unesc(cat))
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
    ap.add_argument("--type", default="", help="업태구분명 필터(예: 일반미용업), 생략하면 전체")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--max-reviews", type=int, default=30)
    ap.add_argument("--out", default="out")
    ap.add_argument("--shard", default="0/1", help="i/n: 대상을 n등분해 i번째만 처리(병렬 실행용, 프로세스마다 --out을 다르게)")
    ap.add_argument("--resume", action="store_true", help="--out 파일에 이미 기록된 관리번호는 건너뛰고 이어서 기록")
    ap.add_argument("--chrome", default=None, help="chrome 실행 파일 경로(생략하면 playwright 기본 브라우저)")
    a = ap.parse_args()

    rows = [r for r in csv.DictReader(open(a.csv, encoding="cp949", newline=""))
            if r["영업상태명"] == "영업/정상" and a.region in r["도로명주소"] and (not a.type or r["업태구분명"] == a.type)
            and "피부미용업" not in r["위생업태명"] and not EXCL_NAME.search(r["사업장명"])]
    if a.limit:
        rows = rows[: a.limit]
    si, sn = map(int, a.shard.split("/"))
    rows = rows[si::sn]
    sp = f"{a.out}_shops.csv"
    resume = a.resume and os.path.exists(sp)
    if resume:
        done = {r["관리번호"] for r in csv.DictReader(open(sp, encoding="utf-8-sig", newline=""))}
        rows = [r for r in rows if r["관리번호"] not in done]
    mode = "a" if resume else "w"
    print(f"대상 {len(rows)}곳")

    with sync_playwright() as p, open(f"{a.out}_reviews.csv", mode, encoding="utf-8-sig", newline="") as fr, \
            open(sp, mode, encoding="utf-8-sig", newline="") as fs:
        b = p.chromium.launch(executable_path=a.chrome, args=["--no-sandbox"])
        wr, ws = csv.writer(fr), csv.writer(fs)
        if not resume:
            wr.writerow(["관리번호", "사업장명", "place_id", "nickname", "date", "visit", "content"])
            ws.writerow(["관리번호", "사업장명", "도로명주소", "place_id", "네이버주소", "match_level", "naver_category", "리뷰수"])
        for i, r in enumerate(rows, 1):
            ctx = b.new_context(locale="ko-KR")  # 가게마다 새 컨텍스트: 한 세션으로 ~50회 넘게 검색하면 결과가 비는 현상 회피
            pg = ctx.new_page()
            try:
                hit = find_place(pg, r)
                if hit and EXCL_CAT.search(hit[4]):
                    hit = hit[:3] + ("제외(카테고리)", hit[4])  # 피부·네일 등으로 분류된 곳은 수집 안 함
                revs = read_reviews(pg, hit[0], a.max_reviews) if hit and hit[3] == "확정" else []  # 후보는 리뷰 미수집
            except Exception as e:  # 한 곳 실패가 전체를 멈추지 않게
                print("  오류:", r["사업장명"], e); hit, revs = None, []
            ctx.close()
            for v in revs:
                wr.writerow([r["관리번호"], r["사업장명"], hit[0], v["nickname"], v["date"], v["visit"], v["content"]])
            ws.writerow([r["관리번호"], r["사업장명"], r["도로명주소"], hit[0] if hit else "", hit[2] if hit else "", hit[3] if hit else "", hit[4] if hit else "", len(revs)])
            fr.flush(); fs.flush()
            print(f"[{i}/{len(rows)}] {r['사업장명']} -> {hit[3] + ' ' + hit[0] if hit else '매칭 실패'}, 리뷰 {len(revs)}")
            time.sleep(random.uniform(2, 4))
        b.close()


if __name__ == "__main__":
    main()
