-- 수집 데이터 적재용. 기존 review 테이블(회원 작성 리뷰, m_no 필요)과 분리.
CREATE TABLE ext_shop (
  mgmt_no       VARCHAR(40)  PRIMARY KEY,   -- 인허가 관리번호
  name          VARCHAR(100) NOT NULL,
  road_address  VARCHAR(200),
  place_id      VARCHAR(20),                -- 네이버 장소 ID
  naver_address VARCHAR(200),
  match_level   VARCHAR(20),                -- 확정/후보/제외(카테고리)/빈값(실패)
  category      VARCHAR(100),
  review_cnt    INT NOT NULL DEFAULT 0,
  KEY (place_id)
) DEFAULT CHARSET=utf8mb4;

CREATE TABLE ext_review (
  id        BIGINT AUTO_INCREMENT PRIMARY KEY,
  mgmt_no   VARCHAR(40) NOT NULL,
  nickname  VARCHAR(100),
  visit_date DATE,
  visit_no  VARCHAR(20),                    -- "N번째 방문"
  content   TEXT,
  FOREIGN KEY (mgmt_no) REFERENCES ext_shop(mgmt_no),
  KEY (mgmt_no)
) DEFAULT CHARSET=utf8mb4;
