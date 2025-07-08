SET NAMES utf8mb4;

-- ✅ 데이터베이스 생성 및 선택
CREATE DATABASE IF NOT EXISTS oz_db DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;
USE oz_db;

-- ✅ 대분류 테이블
CREATE TABLE category_large (
    large_category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- ✅ 중분류 테이블 (대분류 참조)
CREATE TABLE category_medium (
    category_medium_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    large_category_id INT NOT NULL
);

-- ✅ 소분류 테이블 (중분류 참조)
CREATE TABLE category_small (
    category_small_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category_medium_id INT NOT NULL
);

-- ✅ 배송 방법 테이블
CREATE TABLE delivery_method (
    delivery_method_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- ✅ 포장 방법 테이블
CREATE TABLE packaging_type (
    packaging_type_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- ✅ 별도문의 문구 테이블
CREATE TABLE custom_note (
    custom_note_id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL
);

-- ✅ 제품 테이블 (분류, 배송, 문구 참조)
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

INSERT INTO product (
  product_id, name, period, supply_price, description, image_url,
  delivery_method_id, custom_note_id, product_attachment_id,
  packaging_type_id, product_pricing_id,
  category_large_id, category_medium_id, category_small_id, created_at
) VALUES (
  4292, '극세사 인형 보더 쿠션', NULL, 4800,
  '말랑 쫀득해서 귀여운 측면 특징의 인형 쿠션',
  'https://cdn.ozjejakso.com/oz/01bf1068-6094-45dc-bb8e-200f86d3ac12.jpg?w=550&h=550&q=95&f=webp',
  1, 1, NULL, 1, 1001, 197, 198, NULL, NOW()
),
(4322, '바디필로우 인형', NULL, 15700, 
'원하는 캐릭터의 형태로 제작할 수 있는 바디필로우',
'https://cdn.ozjejakso.com/oz/0724991e-5091-4886-b5ec-7d16ec95ced8.png?w=550&h=550&q=95&f=webp',
  1, 1, NULL, 1, 1002, 197, 198, NULL, NOW()
),
(
  4351, '커스텀 캐릭터 파우치', 6500,
  '내가 원하는 캐릭터로 커스텀 제작할 수 있는 보들보들 파우치',
  'https://cdn.ozjejakso.com/oz/b96b4d71-7ca6-4093-9688-8f9d0524ea00.png?w=550&h=550&q=95&f=webp',
  1, 1, NULL, 1, 1004, 197, 198, NULL, NOW()
),
(
  4334, '극세사 인형 보더 쿠션 키링', 3200,
  '원하는 캐릭터로 제작할 수 있는 보더 쿠션 키링',
  'https://cdn.ozjejakso.com/oz/60467d41-472f-4a55-9923-d0201ed50357.png?w=550&h=550&q=95&f=webp',
  1, 1, NULL, 1, 1005, 197, 200, NULL, NOW()
),
(
  4299, '인형 키링', 7800,
  '컬러부터 자수까지 원하는 대로 제작하는 인형 키링',
  'https://cdn.ozjejakso.com/oz/1da16242-4332-4b27-8801-8a445a61dbfc.png?w=550&h=550&q=95&f=webp',
  1, 1, NULL, 1, 1006, 197, 200, NULL, NOW()
),
(
  3635, '프린팅 인형 키링', 13500,
  '사진으로 쉽게 만들 수 있는 커스텀 인형 키링',
  'https://cdn.ozjejakso.com/oz/e7d2a763-079a-4a9c-80ba-4a832ebe1cfd.png?w=550&h=550&q=95&f=webp',
  1, 1, NULL, 1, 1007, 197, 200, NULL, NOW()
);

-- ✅ 옵션 그룹 테이블 (ex. 사이즈, 두께 등)
CREATE TABLE product_option_group (
    product_option_group_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL, -- 외래키
    name VARCHAR(100) NOT NULL
);

INSERT INTO product_option_group (product_option_group_id, product_id, name) VALUES 
  (1, 4292, '사이즈'),
  (2, 4292, '쿠션 두께');

-- ✅ 옵션 항목 테이블 (옵션 그룹에 속함)
CREATE TABLE product_option_value (
	product_option_value_id INT AUTO_INCREMENT PRIMARY KEY,
	product_option_group_id INT, -- 외래키
    value VARCHAR(100) NOT NULL
);

INSERT INTO product_option_value (product_option_value_id, product_option_group_id, value) VALUES 
  (1, 1, '150x200'), (2, 1, '200x300'), (3, 1, '250x300'),
  (4, 1, '300x350'), (5, 1, '300x400'), (6, 1, '400x450'), (7, 1, '400x550');

  INSERT INTO product_option_value (product_option_value_id, product_option_group_id, value) VALUES 
  (8, 2, '두께 없음'), (9, 2, '30mm'), (10, 2, '50mm'), (11, 2, '80mm');

-- ✅ 수량별 가격 정보 테이블 (도매가별)
CREATE TABLE product_pricing (
	product_pricing_id INT AUTO_INCREMENT PRIMARY KEY,
    quantity_range VARCHAR(100) NOT NULL,
    unit_price VARCHAR(50),
    production_time VARCHAR(100),
    supply_price VARCHAR(50),
    shipping_fee VARCHAR(100)
);

INSERT INTO product_pricing (
  product_pricing_id, quantity_range, unit_price, production_time, supply_price, shipping_fee
) VALUES (1001, '300개', '5280원', '20~23일', 4800, 480), -- 극세사 인형 보더 쿠션
(1002, '500개', '17,270원', '80~120일', 15700, 1570), -- 바디 필로우 인형
(1003, '500개', '8,030원', '80~120일', 7300, 730), -- 불가사리 인형
(1004, '500개', '7,150원', '80~120일', 6500, 650), -- 커스텀 캐릭터 파우치
(1005, '300개', '3,520원', '23~25일', 3200, 320), -- 극세사 인형 보더 쿠션 키링
(1006, '500개', '8,580원', '80~120일', 7800, 780), -- 인형 키링
(1007, '1개', '14,850원', '5~10일', 13500, 1350); -- 프린팅 인형 키링

-- ✅ 상세 설명 세분화 테이블
-- CREATE TABLE product_detail_note (
--     product_detail_note_id INT AUTO_INCREMENT PRIMARY KEY,
--     main_description TEXT,
--     custom_tip TEXT,
--     feature_highlight TEXT
-- );

-- ✅ 부가 구성 요소 (ex. 고리 종류 등)
CREATE TABLE product_attachment (
	product_attachment_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

-- ✅ 옵션 표시 메타 정보 (순서, 설명)
-- CREATE TABLE option_display_meta (
--     option_display_meta_id INT AUTO_INCREMENT PRIMARY KEY,
--     option_group_id INT NOT NULL,
--     display_order INT,
--     description TEXT
-- );

-- ✅ 중분류 기준 제품 조회 뷰
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
