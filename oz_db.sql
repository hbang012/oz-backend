SET NAMES utf8mb4;

-- 데이터베이스 생성 및 선택
CREATE DATABASE oz_db DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;
USE oz_db;

-- ✅ Gnb 테이블
CREATE TABLE gnb_menu (
  id INT PRIMARY KEY AUTO_INCREMENT,
  label VARCHAR(50) NOT NULL,         -- 메뉴 이름 (예: '제작소', '문구')
  href VARCHAR(255) DEFAULT NULL,     -- 링크 주소 (예: '/product?category=2')
  parent_id INT DEFAULT NULL,         -- 상위 메뉴 ID, NULL이면 최상위
  depth TINYINT DEFAULT 0,            -- 메뉴 깊이 (0: 루트, 1: 하위, 2: 하위의 하위)
  sort_order INT DEFAULT 0,           -- 정렬 우선순위
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ✅ 상위 메뉴들
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(1, '오즈소개', '/solution', NULL, 0, 1),
(2, '문의하기', '/contact', NULL, 0, 2),
(3, '제작소', '/product', NULL, 0, 3),
(4, '콘텐츠', NULL, NULL, 0, 4);

-- ✅ '제작소' 하위 카테고리 (대분류)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(10, '인형/패브릭', '/product?category=197', 3, 1, 1),
(11, '문구', '/product?category=2', 3, 1, 2),
(12, '라이프스타일', '/product?category=25', 3, 1, 3),
(13, '테크/오피스', '/product?category=78', 3, 1, 4),
(14, '의류/잡화', '/product?category=99', 3, 1, 5),
(15, '패키지', '/product?category=100', 3, 1, 6),
(16, '브랜드 키트', '/product?category=207', 3, 1, 7),
(17, '홍보물/전시', '/product?category=101', 3, 1, 8);

-- ✅ '콘텐츠' 하위 메뉴
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(20, '포트폴리오', '/portfolio', 4, 1, 1),
(21, '매거진', '/blog', 4, 1, 2);

-- ⬇ 인형/패브릭 (parent_id = 10)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(30, '인형', '/product?category=198', 10, 2, 1),
(31, '키링', '/product?category=200', 10, 2, 2),
(32, '쿠션&방석', '/product?category=199', 10, 2, 3),
(33, '패브릭포스터', '/product?category=202', 10, 2, 4),
(34, '담요', '/product?category=209', 10, 2, 5);

-- ⬇ 문구 (parent_id = 11)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(40, '스티커', '/product?category=3', 11, 2, 1),
(41, '엽서/카드', '/product?category=1', 11, 2, 2),
(42, '키링', '/product?category=4', 11, 2, 3),
(43, '필기구', '/product?category=6', 11, 2, 4),
(44, '메모지/메모패드', '/product?category=7', 11, 2, 5),
(45, '틴케이스', '/product?category=8', 11, 2, 6),
(46, '콜렉트북/앨범/액자', '/product?category=9', 11, 2, 7),
(47, '캘린더', '/product?category=11', 11, 2, 8),
(48, '파일/L홀더', '/product?category=12', 11, 2, 9),
(49, '스탬프', '/product?category=186', 11, 2, 10),
(50, '뱃지/버튼', '/product?category=157', 11, 2, 11),
(51, '클립/북마크/집게', '/product?category=13', 11, 2, 12),
(52, '자석(마그넷)', '/product?category=187', 11, 2, 13);

-- ⬇ 라이프스타일 (parent_id = 12)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(60, '텀블러', '/product?category=49', 12, 2, 1),
(61, '컵', '/product?category=50', 12, 2, 2),
(62, '여행', '/product?category=56', 12, 2, 3),
(63, '캠핑', '/product?category=172', 12, 2, 4),
(64, '악세서리', '/product?category=203', 12, 2, 5),
(65, '계절용품', '/product?category=58', 12, 2, 6),
(66, '매트', '/product?category=59', 12, 2, 7),
(67, '스포츠', '/product?category=57', 12, 2, 8),
(68, '반려동물', '/product?category=55', 12, 2, 9),
(69, '차량용', '/product?category=185', 12, 2, 10);

-- ⬇ 테크/오피스 (parent_id = 13)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(70, '모바일 악세서리', '/product?category=85', 13, 2, 1),
(71, '마우스패드', '/product?category=86', 13, 2, 2),
(72, '충전/배터리', '/product?category=88', 13, 2, 3),
(73, 'USB', '/product?category=89', 13, 2, 4),
(74, '계절용품', '/product?category=204', 13, 2, 5),
(75, '기타 데스크제품', '/product?category=87', 13, 2, 6);

-- ⬇ 의류/잡화 (parent_id = 14)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(80, '상의', '/product?category=103', 14, 2, 1),
(81, '하의', '/product?category=104', 14, 2, 2),
(82, '파우치/지갑', '/product?category=107', 14, 2, 3),
(83, '가방/에코백', '/product?category=106', 14, 2, 4),
(84, '모자', '/product?category=105', 14, 2, 5),
(85, '슬리퍼', '/product?category=188', 14, 2, 6),
(86, '홈웨어', '/product?category=184', 14, 2, 7),
(87, '앞치마', '/product?category=181', 14, 2, 8);

-- ⬇ 패키지 (parent_id = 15)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(90, '박스', '/product?category=124', 15, 2, 1),
(91, '쇼핑백', '/product?category=125', 15, 2, 2),
(92, '봉투/파우치', '/product?category=108', 15, 2, 3),
(93, '파우치', '/product?category=177', 15, 2, 4),
(94, '지퍼백', '/product?category=123', 15, 2, 5),
(95, '포장작업', '/product?category=126', 15, 2, 6);

-- ⬇ 브랜드 키트 (parent_id = 16)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(100, '키트 상품', '/product?category=208', 16, 2, 1);

-- ⬇ 홍보물/전시 (parent_id = 17)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(110, '현수막', '/product?category=131', 17, 2, 1),
(111, '시트지', '/product?category=132', 17, 2, 2),
(112, '배너/등신대', '/product?category=133', 17, 2, 3),
(113, '토퍼', '/product?category=134', 17, 2, 4),
(114, '기타 홍보물', '/product?category=136', 17, 2, 5);

-- ⬇ 스티커의 소분류 (parent_id = 40)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(200, '리무버블지', '/product?category=19', 40, 3, 1),
(201, '아트지', '/product?category=18', 40, 3, 2),
(202, '모조지', '/product?category=20', 40, 3, 3),
(203, '크라프트지', '/product?category=21', 40, 3, 4),
(204, '홀로그램', '/product?category=162', 40, 3, 5),
(205, '투명지', '/product?category=24', 40, 3, 6),
(206, '띠부띠부', '/product?category=22', 40, 3, 7),
(207, '에폭시', '/product?category=23', 40, 3, 8),
(208, '특수지', '/product?category=189', 40, 3, 9),
(209, '타투 스티커', '/product?category=196', 40, 3, 10);

-- ⬇ 엽서/카드의 소분류 (parent_id = 41)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(210, '엽서', '/product?category=15', 41, 3, 1),
(211, '카드', '/product?category=16', 41, 3, 2);

-- ⬇ 키링의 소분류 (parent_id = 42)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(212, '아크릴 키링', '/product?category=26', 42, 3, 1),
(213, 'PVC 말랑키링', '/product?category=176', 42, 3, 2),
(214, '인형/패브릭 키링', '/product?category=28', 42, 3, 3),
(215, '금속 키링', '/product?category=29', 42, 3, 4);

-- ⬇ 필기구의 소분류 (parent_id = 43)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(216, '볼펜', '/product?category=39', 43, 3, 1),
(217, '필기구 세트', '/product?category=40', 43, 3, 2),
(218, '기타 문구용품', '/product?category=168', 43, 3, 3);

-- ⬇ 메모지/메모패드의 소분류 (parent_id = 44)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(219, '포스트잇', '/product?category=41', 44, 3, 1),
(220, '떡메모지', '/product?category=42', 44, 3, 2),
(221, '메모패드', '/product?category=43', 44, 3, 3);

-- ⬇ 콜렉트북/앨범/액자의 소분류 (parent_id = 46)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(222, '콜렉트북', '/product?category=44', 46, 3, 1),
(223, '포토카드홀더', '/product?category=45', 46, 3, 2),
(224, '액자', '/product?category=46', 46, 3, 3);

-- ⬇ 뱃지/버튼의 소분류 (parent_id = 50)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(225, '뱃지', '/product?category=158', 50, 3, 1);

-- ⬇ 컵의 소분류 (parent_id = 61)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(226, '머그컵', '/product?category=60', 61, 3, 1),
(227, '유리컵', '/product?category=61', 61, 3, 2),
(228, '술잔', '/product?category=161', 61, 3, 3),
(229, '종이컵/컵홀더', '/product?category=62', 61, 3, 4),
(230, '기타 컵', '/product?category=167', 61, 3, 5);

-- ⬇ 여행의 소분류 (parent_id = 62)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(231, '가방/파우치', '/product?category=79', 62, 3, 1),
(232, '충전기/어댑터', '/product?category=80', 62, 3, 2),
(233, '여권/네임택', '/product?category=81', 62, 3, 3);

-- ⬇ 계절용품(라이프)의 소분류 (parent_id = 65)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(234, '부채', '/product?category=83', 65, 3, 1),
(235, '핫팩', '/product?category=84', 65, 3, 2);

-- ⬇ 스포츠의 소분류 (parent_id = 67)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(236, '골프', '/product?category=82', 67, 3, 1),
(237, '기타', '/product?category=178', 67, 3, 2);

-- ⬇ 모바일 악세서리의 소분류 (parent_id = 70)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(238, '휴대폰/아이패드 케이스', '/product?category=92', 70, 3, 1),
(239, '에어팟/버즈 케이스', '/product?category=93', 70, 3, 2),
(240, '스마트톡', '/product?category=94', 70, 3, 3),
(241, '휴대폰 카드홀더', '/product?category=98', 70, 3, 4),
(242, '스트랩', '/product?category=180', 70, 3, 5);

-- ⬇ 마우스패드의 소분류 (parent_id = 71)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(243, '일반 마우스패드', '/product?category=155', 71, 3, 1),
(244, '장패드', '/product?category=156', 71, 3, 2),
(245, '충전형 마우스패드', '/product?category=165', 71, 3, 3);

-- ⬇ 충전/배터리의 소분류 (parent_id = 72)
INSERT INTO gnb_menu (id, label, href, parent_id, depth, sort_order) VALUES
(246, '보조배터리', '/product?category=95', 72, 3, 1),
(247, '충전기', '/product?category=96', 72, 3, 2),
(248, '멀티허브/케이블', '/product?category=97', 72, 3, 3);

-- SELECT * FROM gnb_menu ORDER BY sort_order ASC; -- 


-- 대분류 테이블
CREATE TABLE category_large (
    large_category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- 중분류 테이블 (대분류 참조)
CREATE TABLE category_medium (
    category_medium_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    large_category_id INT NOT NULL
);

-- 소분류 테이블 (중분류 참조)
CREATE TABLE category_small (
    category_small_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category_medium_id INT NOT NULL
);

-- 대분류 등록
INSERT INTO category_large (large_category_id, name) VALUES
(197, '인형/패브릭'),
(2, '문구'),
(25, '라이프스타일'),
(78, '테크/오피스'),
(99, '의류/잡화'),
(100, '패키지'),
(207, '브랜드 키트'),
(101, '홍보물/전시');

-- SELECT * FROM category_large;

-- 중분류 등록
INSERT INTO category_medium (category_medium_id, name, large_category_id) VALUES
(198, '인형', 197),
(199, '쿠션&방석', 197),
(200, '키링', 197),
(202, '패브릭포스터', 197),
(209, '담요', 197),

(3, '스티커', 2),
(1, '엽서/카드', 2),
(4, '키링', 2),
(5, '노트/다이어리', 2),
(6, '필기구', 2),
(7, '메모지/메모패드', 2),
(8, '틴케이스', 2),
(9, '콜렉트북/앨범/액자', 2),
(190, '스탠드/등신대', 2),
(10, '테이프', 2),
(11, '캘린더', 2),
(12, '파일/L홀더', 2),
(186, '스탬프', 2),
(157, '뱃지/버튼', 2),
(13, '클립/북마크/집게', 2),
(187, '자석(마그넷)', 2),

(50, '컵', 25),
(51, '우산', 25),
(52, '리빙', 25),
(53, '욕실', 25),
(54, '주방', 25),
(56, '여행', 25),
(172, '캠핑', 25),
(203, '악세서리', 25),
(58, '계절용품', 25),
(59, '매트', 25),
(57, '스포츠', 25),
(55, '반려동물', 25),
(185, '차량용', 25),

(85, '모바일 악세서리', 78),
(86, '마우스패드', 78),
(88, '충전/배터리', 78),
(89, 'USB', 78),
(204, '계절용품', 78),
(87, '기타 데스크제품', 78),

(103, '상의', 99),
(104, '하의', 99),
(107, '파우치/지갑', 99),
(106, '가방/에코백', 99),
(105, '모자', 99),
(188, '슬리퍼', 99),
(184, '홈웨어', 99),
(181, '앞치마', 99),

(124, '박스', 100),
(125, '쇼핑백', 100),
(108, '봉투/파우치', 100),
(177, '파우치', 100),
(123, '지퍼백', 100),
(126, '포장작업', 100),

(208, '키트 상품', 207),

(131, '현수막', 101),
(132, '시트지', 101),
(133, '배너/등신대', 101),
(134, '토퍼', 101),
(136, '기타 홍보물', 101);

-- SELECT * FROM category_medium;

-- 소분류 등록
INSERT INTO category_small (category_small_id, name, category_medium_id) VALUES
-- 스티커 (3)
(19, '리무버블지', 3),
(18, '아트지', 3),
(20, '모조지', 3),
(21, '크라프트지', 3),
(162, '홀로그램', 3),
(24, '투명지', 3),
(22, '띠부띠부', 3),
(23, '에폭시', 3),
(189, '특수지', 3),
(196, '타투 스티커', 3),

-- 엽서/카드 (1)
(15, '엽서', 1),
(16, '카드', 1),

-- 키링 (4)
(26, '아크릴 키링', 4),
(176, 'PVC 말랑키링', 4),
(28, '인형/패브릭 키링', 4),
(29, '금속 키링', 4),

-- 노트/다이어리 (5)
(33, '다이어리', 5),
(34, '스프링노트', 5),
(35, '무선제본 노트', 5),
(38, '수첩', 5),

-- 필기구 (6)
(39, '볼펜', 6),
(40, '필기구 세트', 6),
(168, '기타 문구용품', 6),

-- 메모지/메모패드 (7)
(41, '포스트잇', 7),
(42, '떡메모지', 7),
(43, '메모패드', 7),

-- 콜렉트북/앨범/액자 (9)
(44, '콜렉트북', 9),
(45, '포토카드홀더', 9),
(46, '액자', 9),

-- 테이프 (10)
(48, '마스킹테이프', 10),
(47, '박스테이프', 10),

-- 컵 (50)
(60, '머그컵', 50),
(61, '유리컵', 50),
(161, '술잔', 50),
(62, '종이컵/컵홀더', 50),
(167, '기타 컵', 50),

-- 우산 (51)
(63, '장우산', 51),
(64, '단우산', 51),

-- 리빙 (52)
(66, '시계', 52),
(67, '멀티클리너', 52),
(68, '살균박스', 52),
(69, '향/캔들', 52),
(163, '인테리어', 52),
(182, '거울', 52),

-- 욕실 (53)
(171, '수건', 53),
(71, '비누바', 53),
(72, '양치제품', 53),
(73, '살균기', 53),
(175, '욕실용품 세트', 53),

-- 주방 (54)
(74, '식기류', 54),
(75, '코스터', 54),
(76, '오프너', 54),
(77, '도마', 54),
(164, '기타 주방용품', 54),

-- 여행 (56)
(79, '가방/파우치', 56),
(80, '충전기/어댑터', 56),
(81, '여권/네임택', 56),

-- 모바일 악세서리 (85)
(92, '휴대폰/아이패드 케이스', 85),
(93, '에어팟/버즈 케이스', 85),
(94, '스마트톡', 85),
(98, '휴대폰 카드홀더', 85),
(180, '스트랩', 85),

-- 마우스패드 (86)
(155, '일반 마우스패드', 86),
(156, '장패드', 86),
(165, '충전형 마우스패드', 86),

-- 충전/배터리 (88)
(95, '보조배터리', 88),
(96, '충전기', 88),
(97, '멀티허브/케이블', 88),

-- USB (89)
(90, '거치대/스탠드', 89),
(91, '마우스/키보드', 89),

-- 계절용품 (204)
(205, '선풍기', 204),
(206, '손난로', 204);

-- SELECT * FROM category_small;

-- 배송 방법 테이블
CREATE TABLE delivery_method (
    delivery_method_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
INSERT INTO delivery_method (delivery_method_id, name) VALUES (1, '택배');

-- 포장 방법 테이블
CREATE TABLE packaging_type (
    packaging_type_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
INSERT INTO packaging_type (packaging_type_id, name) VALUES (1, '개별포장');

-- 별도문의 문구 테이블
CREATE TABLE custom_note (
    custom_note_id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL
);
INSERT INTO custom_note (custom_note_id, content)
VALUES (1, '※ 커스텀 제품은 제작 전 상담이 필요합니다.');

-- 제품 테이블 (분류, 배송, 문구 참조)
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    period VARCHAR(255), 
    supply_price INT NOT NULL,
	shipping_fee INT AS (supply_price * 0.1) STORED, -- 부가세 10%
    description TEXT,
	image_url VARCHAR(255) NOT NULL,
    delivery_method_id INT, -- 배송 방법 외래키
    custom_note_id INT, -- 별도 문의 외래키
    product_attachment_id INT, -- 고리 외래키
	packaging_type_id INT, -- 포장방법 외래키
    product_pricing_id INT NOT NULL, -- 가격 외래키
    category_large_id INT NOT NULL, 
	category_medium_id INT NOT NULL,
    category_small_id INT NOT NULL,
    created_at DATETIME DEFAULT NOW()
);

-- 상세페이지 이미지 추가
ALTER TABLE product
  ADD COLUMN sub_image_urls JSON NULL AFTER image_url;
  
-- 인기순 추가
ALTER TABLE product
  ADD COLUMN like_count INT NOT NULL DEFAULT 0;

 DESCRIBE product;


-- 옵션 그룹 테이블 (ex. 사이즈, 두께 등)
CREATE TABLE product_option_group (
    product_option_group_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL, -- 외래키
    name VARCHAR(100) NOT NULL
);

-- 옵션 항목 테이블 (옵션 그룹에 속함)
CREATE TABLE product_option_value (
	product_option_value_id INT AUTO_INCREMENT PRIMARY KEY,
	product_option_group_id INT, -- 외래키
    value VARCHAR(100) NOT NULL
);


-- 수량별 가격 정보 테이블 (도매가별)
CREATE TABLE product_pricing (
	product_pricing_id INT AUTO_INCREMENT PRIMARY KEY,
    quantity_range VARCHAR(100) NOT NULL, -- 최소 갯수
    unit_price VARCHAR(50), -- 개당 단가
    production_time VARCHAR(100), -- 기본단가 제작 기간
    supply_price VARCHAR(50), -- 공급가
    shipping_fee VARCHAR(100) -- 배송비
);

INSERT IGNORE INTO product_pricing  (
product_pricing_id, quantity_range, unit_price, production_time, supply_price, shipping_fee
) VALUES
-- 1005: 극세사 인형 보더 쿠션
(1005, '300개', '5,280원', '20~23일', 4800, 0),

-- 1006: 바디필로우 인형
(1006, '500개', '17,270원', '80~120일', 15700, 0),

-- 1007: 불가사리형 인형 키링
(1007, '500개', '8,030원', '80~120일', 7300, 0),

-- 1008: 커스텀 캐릭터 파우치
(1008, '500개', '7,150원', '80~120일', 6500, 0),

-- 1009: 극세사 인형 보더 쿠션 키링
(1009, '300개', '3,520원', '23~25일', 3200, 0),

-- 1010: 인형 키링
(1010, '500개', '8,580원', '80~120일', 7800, 0),

-- 1011: 프린팅 인형 키링
(1011, '1개', '14,850원', '5~10일', 13500, 3000),

-- 1012: 머그컵
(1012, '500개', '14,300원', '5~10일', 13000, 3500),

-- 1013: 술잔
(1013, '1개', '9,900원', '7~10일', 8800, 3000),

-- 1014: 종이컵/컵홀더
(1014, '5,000개', '44원', '7~14일', 44, 0),

-- 1015: 기타 컵
(1015, '1개', '14,300원', '5~10일', 13750, 3500),

-- 1016: 리무버블 pvc A3 스티커
(1016, '500개', '5,830원', '20~30일', 5300, 3500),

-- 1017: 리무버블 유포지 스티커 150x50mm
(1017, '1개', '561원', '20~30일', 408, 0),

-- 1018: 리무버블 유포지 스티커 180x80mm
(1018, '1개', '4,488원', '7~10일', 408, 0),

-- 1019: 리무버블 유포지 스티커 A3
(1019, '1개', '5,830원', '20~30일', 5300, 3500),

-- 1020: 리무버블 유포지 스티커 110x180mm
(1020, '1개', '4,488원', '20~30일', 408, 0),

-- 1022: 아트지 A3 씰스티커 
(1022 , '1개', '3,520원', '20~30일', 3200, 320),

-- 1023: 2단 라운드컵 (머그컵)
(1023, '1개', '14,300원', '5~10일',13000, 3500),
 
 -- 1024: 고블렛잔 (유리컵)
(1024, '1개', '12,540원', '7~10일',11400, 3500),

-- 1025: 24k금 각인 소주잔
(1025, '1개', '9,900원',  '7~10일', 9000, 3000),

-- 1026: 일반 컵홀더 (종이컵/컵홀더)
(1026, '5,000개', '44원', '7~14일', 40, 0),
  
-- 1027: 시리얼볼 450ml (기타 컵)
(1027, '1개', '14,300원', '5~10일', 13750, 3500);


SELECT 
  p.*,
  pp.quantity_range
FROM product p
JOIN product_pricing pp ON p.product_pricing_id = pp.product_pricing_id;

-- 이미 있는 ID 조회
SELECT product_pricing_id
FROM product_pricing
WHERE product_pricing_id IN (1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020);

SELECT COUNT(*) FROM product_pricing;

SELECT * FROM product_pricing WHERE product_pricing_id BETWEEN 1016 AND 1020;

-- 총 금액 계산때문에 따로 빼둠
CREATE TABLE product_price_tier (
  product_price_tier_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  min_quantity INT NOT NULL,
  unit_price INT NOT NULL,
  production_time VARCHAR(100) -- 수량별로 달라지는 티어 단가와 납기
);

-- 상품별 수량별 단가 티어 정리
INSERT INTO product_price_tier (product_id, min_quantity, unit_price, production_time) VALUES
  -- 4342: 불가사리형 인형 키링
  (4342, 500, 8030, '80~100일'),
  (4342, 1000, 7370, '100~120일'),

  -- 4351: 커스텀 캐릭터 파우치
  (4351, 500, 7150, '70~90일'),
  (4351, 1000, 6600, '90~120일'),

  -- 4334: 극세사 인형 보더 쿠션 키링
  (4334, 300, 3520, '15~20일'),
  (4334, 501, 3300, '20~23일'),
  (4334, 1001, 3190, '23~25일'),
  (4334, 2001, 3080, '25~28일'),

  -- 4299: 인형 키링
  (4299, 500, 8580, '80~110일'),
  (4299, 1000, 8580, '100~130일'),

  -- 3635: 프린팅 인형 키링
  (3635, 1, 14850, '5~7일'),
  (3635, 50, 14300, '7~10일'),
  (3635, 100, 13970, '10~13일'),

  -- 3297: 아트지 A3 씰스티커
  (3297, 1, 3520, '20~30일'),
  (3297, 50, 3300, '20~30일'),

  -- 4281: 리무버블 유포지 스티커 150x50mm
  (4281, 1, 561, '5~10일'),
  (4281, 51, 561, '7~12일'),

  -- 4282: 리무버블 유포지 스티커 180x80mm
  (4282, 1, 561, '5~10일'),
  (4282, 51, 561, '7~12일'),

  -- 3266: 리무버블 유포지 스티커 110x180mm
  (3266, 1, 561, '5~10일'),
  (3266, 51, 561, '7~12일'),

  -- 4283: 리무버블 유포지 스티커 150x80mm
  (4283, 1, 561, '5~10일'),
  (4283, 51, 561, '7~12일'),

  -- 3265: 리무버블 유포지 스티커 180x260mm
  (3265, 1, 561, '5~10일'),
  (3265, 51, 561, '7~12일'),

  -- 3267: 리무버블 유포지 스티커 80x120mm
  (3267, 1, 561, '5~10일'),
  (3267, 51, 561, '7~12일');

SELECT * FROM product_price_tier;

-- SELECT 
--   p.product_id,
--   p.name AS product_name,
--   t.min_quantity,
--   t.unit_price
-- FROM product_price_tier t
-- JOIN product p ON p.product_id = t.product_id
-- ORDER BY p.product_id, t.min_quantity;

-- SELECT * FROM product_price_tier WHERE product_id = 4342;

-- ALTER TABLE product_pricing
--   MODIFY COLUMN shipping_fee INT, -- 배송비 숫자 (계산용)
--   ADD COLUMN shipping_note VARCHAR(100); -- 설명용 텍스트
  



-- 예시
INSERT INTO product (
  product_id, name, supply_price, description, image_url,
  delivery_method_id, custom_note_id, product_attachment_id,
  packaging_type_id, product_pricing_id,
  category_large_id, category_medium_id, category_small_id
) VALUES (
  4342,
  '불가사리형 인형 키링',
  7300,
  '작고 귀여운 커스텀 인형 키링',
  '/images/starfish-doll-keyring.png',category_large
  1,
  1,
  NULL,
  1,
  1007,
  197,
  200,
  28
);

SELECT * FROM product ORDER BY created_at DESC;


-- 상세 설명 세분화 테이블
-- CREATE TABLE product_detail_note (
--     product_detail_note_id INT AUTO_INCREMENT PRIMARY KEY,
--     main_description TEXT,
--     custom_tip TEXT,
--     feature_highlight TEXT
-- );

-- 부가 구성 요소 (ex. 고리 종류 등)
CREATE TABLE product_attachment (
	product_attachment_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

-- 옵션 표시 메타 정보 (순서, 설명)
-- CREATE TABLE option_display_meta (
--     option_display_meta_id INT AUTO_INCREMENT PRIMARY KEY,
--     option_group_id INT NOT NULL,
--     display_order INT,
--     description TEXT
-- );

-- 중분류 기준 제품 조회 뷰
CREATE VIEW view_products_by_medium_category AS
SELECT 
    p.id AS product_id,
    p.name AS product_name,
    cm.id AS medium_category_id,
    cm.name AS medium_category_name,
    cl.id AS large_category_id,
    cl.name AS large_category_name,
    cs.id AS small_category_id,
    cs.name AS small_category_name,
    p.production_time,
    p.supply_price,
    p.shipping_fee,
    p.description
FROM product p
JOIN category_small cs ON p.small_category_id = cs.id
JOIN category_medium cm ON cs.medium_category_id = cm.id
JOIN category_large cl ON cm.large_category_id = cl.id;

-- 대분류 기준 제품 조회 뷰
CREATE VIEW view_products_by_large_category AS
SELECT 
    p.id AS product_id,
    p.name AS product_name,
    cl.id AS large_category_id,
    cl.name AS large_category_name,
    cm.id AS medium_category_id,
    cm.name AS medium_category_name,
    cs.id AS small_category_id,
    cs.name AS small_category_name,
    p.production_time,
    p.supply_price,
    p.shipping_fee,
    p.description
FROM product p
JOIN category_small cs ON p.small_category_id = cs.id
JOIN category_medium cm ON cs.medium_category_id = cm.id
JOIN category_large cl ON cm.large_category_id = cl.id;


-- SELECT 
--   p.product_id,
--   p.name AS product_name,
--   cl.name AS large,
--   cm.name AS medium,
--   cs.name AS small,
--   pp.quantity_range,
--   pp.unit_price
-- FROM product p
-- JOIN category_large cl ON p.category_large_id = cl.large_category_id
-- JOIN category_medium cm ON p.category_medium_id = cm.category_medium_id
-- JOIN category_small cs ON p.category_small_id = cs.category_small_id
-- JOIN product_pricing pp ON p.product_pricing_id = pp.product_pricing_id
-- ORDER BY p.product_id;

-- SELECT product_id, category_medium_id, category_small_id;

-- SELECT *
-- FROM product_pricing
-- WHERE product_pricing_id IN (1007, 1002, 1006, 1005, 1004, 1001);

-- SELECT 
--   p.product_id,
--   p.product_pricing_id,
--   pp.product_pricing_id AS pp_exists,
--   p.category_large_id, cl.large_category_id AS cl_exists,
--   p.category_medium_id, cm.category_medium_id AS cm_exists,
--   p.category_small_id, cs.category_small_id AS cs_exists
-- FROM product p
-- LEFT JOIN product_pricing pp ON p.product_pricing_id = pp.product_pricing_id
-- LEFT JOIN category_large cl     ON p.category_large_id    = cl.large_category_id
-- LEFT JOIN category_medium cm    ON p.category_medium_id   = cm.category_medium_id
-- LEFT JOIN category_small cs     ON p.category_small_id    = cs.category_small_id
-- WHERE p.product_id IN (4343,4344,4345,4346,4347,4348);


--  blog_posts 테이블 생성
CREATE TABLE IF NOT EXISTS blog_posts (
  post_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(200) NOT NULL,     -- 글 제목
  description TEXT NOT NULL,     -- 본문/요약
  thumbnail_url VARCHAR(255) NOT NULL, -- 썸네일 이미지 경로
  created_at DATETIME NOT NULL,   -- 작성일 (직접 지정 가능)
  updated_at DATETIME NULL        -- 수정일 (옵션)
) ;

-- 컬럼 기본값 설정
ALTER TABLE blog_posts
  MODIFY COLUMN created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- 예시데이터 넣기
INSERT INTO blog_posts (title, description, thumbnail_url, created_at) VALUES
  (
    '유통업계에 불고 있는 IP 굿즈 열풍',
    'IP 콜라보 굿즈의 사례와 유통업계에서 특히 IP 상품을 많이 선보이는 이유 등을 설명해요',
    '/images/focus-01.png',
    '2024-12-21'
  ),
  (
    '굿즈 열풍의 이유 & 인기많은 굿즈를 위한 4가지 TIP',
    '굿즈는 왜 인기가 많을까요? 브랜드/IP에 어떤 영향과 효과를 줄까요? 또, 성공적인 굿즈 제작을 위해 중요한 4가지 TIP을 공유합니다!',
    '/images/focus-02.png',
    '2024-12-21'
  );

-- 잘 들어갔는지 확인
-- SELECT * FROM blog_posts ORDER BY created_at DESC;


SELECT
  p.*,
  cl.name AS category_large_name,
  cm.name AS category_medium_name,
  cs.name AS category_small_name,
  pp.quantity_range,
  pp.unit_price,
  pp.supply_price,
  pp.production_time
FROM product p
JOIN category_large cl ON p.category_large_id = cl.large_category_id
JOIN category_medium cm ON p.category_medium_id = cm.category_medium_id
JOIN category_small cs ON p.category_small_id = cs.category_small_id
JOIN product_pricing pp ON p.product_pricing_id = pp.product_pricing_id
ORDER BY p.created_at DESC;

