const express = require('express');
const router = express.Router();
const connection = require('../config/mysql');

// 가격 항목 등록
router.post('/pricing', (req, res) => {
  const {
    quantity_range,
    unit_price,
    production_time,
    supply_price,
    shipping_fee,
  } = req.body;

  if (
    !quantity_range ||
    !unit_price ||
    !production_time ||
    !supply_price ||
    !shipping_fee
  ) {
    return res.status(400).send('필수 필드 누락');
  }

  const query = `
    INSERT INTO product_pricing (
      quantity_range, unit_price, production_time, supply_price, shipping_fee
    ) VALUES (?, ?, ?, ?, ?)
  `;
  const values = [
    quantity_range,
    unit_price,
    production_time,
    supply_price,
    shipping_fee,
  ];

  connection.query(query, values, (err, result) => {
    if (err) {
      console.error('가격 등록 실패:', err.message);
      return res.status(500).send('가격 등록 실패');
    }
    res
      .status(201)
      .json({ message: '가격 등록 완료', product_pricing_id: result.insertId });
  });
});

// 가격 항목 전체 조회
router.get('/pricing', (req, res) => {
  connection.query('SELECT * FROM product_pricing', (err, rows) => {
    if (err) {
      console.error('가격 조회 실패:', err.message);
      return res.status(500).send('가격 조회 실패');
    }
    res.json(rows);
  });
});

// 특정 가격 항목 조회
router.get('/pricing/:id', (req, res) => {
  const pricingId = req.params.id;
  const query = 'SELECT * FROM product_pricing WHERE product_pricing_id = ?';

  connection.query(query, [pricingId], (err, rows) => {
    if (err) {
      console.error('가격 항목 개별 조회 실패:', err.message);
      return res.status(500).send('가격 항목 조회 실패');
    }
    if (!rows.length) return res.status(404).send('해당 가격 항목 없음');
    res.json(rows[0]);
  });
});

module.exports = router;
