const express = require('express');
const router = express.Router();
const connection = require('../config/mysql');

// GET /product/:id 특정 제품 상세
router.get('/:id', (req, res) => {
  const { id } = req.params;

  const query = `
    SELECT 
      p.*,
      cl.name AS category_large_name,
      cm.name AS category_medium_name,
      cs.name AS category_small_name,
      pp.quantity_range,
      pp.unit_price,
      pp.supply_price,
      p.sub_image_urls,
      p.like_count
    FROM product p
    JOIN category_large cl ON p.category_large_id = cl.large_category_id
    JOIN category_medium cm ON p.category_medium_id = cm.category_medium_id
    JOIN category_small cs ON p.category_small_id = cs.category_small_id
    JOIN product_pricing pp ON p.product_pricing_id = pp.product_pricing_id
    WHERE p.product_id = ?
  `;

  connection.query(query, [id], (err, result) => {
    if (err) {
      console.error('제품 상세 조회 에러:', err.message);
      return res.status(500).send('DB 오류');
    }
    if (result.length === 0) {
      return res.status(404).send('해당 제품 없음');
    }
    res.json(result[0]);
  });
});

// POST 핸들러
// POST /product - 제품 등록
router.post('/', (req, res) => {
  const {
    name,
    period,
    supply_price,
    description,
    image_url,
    sub_image_urls,
    delivery_method_id,
    custom_note_id,
    product_attachment_id,
    packaging_type_id,
    product_pricing_id,
    category_large_id,
    category_medium_id,
    category_small_id,
  } = req.body;

  if (
    !name ||
    !supply_price ||
    !image_url ||
    !product_pricing_id ||
    !category_large_id ||
    !category_medium_id ||
    !category_small_id
  ) {
    return res.status(400).send('필수 필드 누락');
  }

  const query = `
    INSERT INTO product (
      name, period, supply_price, description, image_url, sub_image_urls, like_count,
      delivery_method_id, custom_note_id, product_attachment_id,
      packaging_type_id, product_pricing_id,
      category_large_id, category_medium_id, category_small_id, created_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
  `;

  const values = [
    name,
    period || null,
    supply_price,
    description || null,
    image_url,
    JSON.stringify(sub_image_urls ?? []),
    0, // like_count 기본값
    delivery_method_id || null,
    custom_note_id || null,
    product_attachment_id || null,
    packaging_type_id || null,
    product_pricing_id,
    category_large_id,
    category_medium_id,
    category_small_id,
  ];

  connection.query(query, values, (err, result) => {
    if (err) {
      console.error('제품 등록 에러:', err.message);
      return res.status(500).send('제품 등록 실패');
    }
    res.status(201).json({ message: '등록 성공', product_id: result.insertId });
  });
});

// 삭제
router.delete('/:id', (req, res) => {
  const productId = req.params.id;

  const query = 'DELETE FROM product WHERE product_id = ?';
  connection.query(query, [productId], (err, result) => {
    if (err) return res.status(500).send('삭제 실패');
    if (result.affectedRows === 0)
      return res.status(404).send('해당 상품 없음');
    res.send('삭제 완료!');
  });
});

// 수정
router.put('/:id', (req, res) => {
  const { id } = req.params;
  const {
    name,
    period,
    supply_price,
    description,
    image_url,
    sub_image_urls,
    like_count,
    delivery_method_id,
    custom_note_id,
    product_attachment_id,
    packaging_type_id,
    product_pricing_id,
    category_large_id,
    category_medium_id,
    category_small_id,
  } = req.body;

  const query = `
    UPDATE product SET
      name = ?, period = ?, supply_price = ?, description = ?, image_url = ?,
      sub_image_urls = ?, like_count = ?,
      delivery_method_id = ?, custom_note_id = ?, product_attachment_id = ?,
      packaging_type_id = ?, product_pricing_id = ?,
      category_large_id = ?, category_medium_id = ?, category_small_id = ?
    WHERE product_id = ?
  `;

  const values = [
    name,
    period || null,
    supply_price,
    description || null,
    image_url,
    JSON.stringify(sub_image_urls ?? []),
    like_count ?? 0,
    delivery_method_id || null,
    custom_note_id || null,
    product_attachment_id || null,
    packaging_type_id || null,
    product_pricing_id,
    category_large_id,
    category_medium_id,
    category_small_id,
    id,
  ];

  connection.query(query, values, (err, result) => {
    if (err) {
      console.error('제품 수정 에러:', err.message);
      return res.status(500).send('수정 실패');
    }
    res.send('수정 완료!');
  });
});

router.get('/', (req, res) => {
  const { category, sort } = req.query;
  let orderBy = 'p.created_at DESC';
  let where = '';
  const params = [];

  // 필터: category(중분류 or 소분류)
  if (category) {
    where =
      'WHERE p.category_large_id = ? OR p.category_medium_id = ? OR p.category_small_id = ?';
    params.push(category, category, category);
  }

  // 정렬 조건
  switch (sort) {
    case 'POPULAR_DESC':
      orderBy = 'p.like_count DESC';
      break;
    case 'MINIMUM_PRICE_ASC':
      orderBy = `
        CAST(REPLACE(REPLACE(pp.unit_price, ',', ''), '원', '') AS UNSIGNED) ASC
      `;
      break;
    case 'MINIMUM_PRICE_DESC':
      orderBy = `
        CAST(REPLACE(REPLACE(pp.unit_price, ',', ''), '원', '') AS UNSIGNED) DESC
      `;
      break;
    case 'MINIMUM_QUANTITY_ASC':
      orderBy = `
        CAST(REPLACE(SUBSTRING_INDEX(pp.quantity_range, '~', 1), '개', '') AS UNSIGNED) ASC
      `;
      break;
    case 'MINIMUM_LEAD_TIME_ASC':
      orderBy = `
        CAST(REPLACE(SUBSTRING_INDEX(pp.production_time, '~', 1), '일', '') AS UNSIGNED) ASC
      `;
      break;
    default:
      orderBy = 'p.created_at DESC';
  }

  const query = `
    SELECT
      p.*,
      p.sub_image_urls,
      p.like_count,
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
    ${where}
    ORDER BY ${orderBy};
  `;

  connection.query(query, params, (err, rows) => {
    if (err) {
      console.error('조회 실패:', err.message);
      return res.status(500).send('조회 실패');
    }
    console.log('조회된 상품 수:', rows.length);
    res.json(rows);
  });
});

module.exports = router;
