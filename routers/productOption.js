const express = require('express');
const router = express.Router();
const connection = require('../config/mysql');

// post 옵션 그룹 + 항목 등록
router.post('/product/:id/options', (req, res) => {
  const productId = req.params.id;
  const { name, values } = req.body;

  if (!name || !Array.isArray(values) || values.length === 0) {
    return res.status(400).send('옵션 그룹명 또는 옵션 값이 누락됐어요');
  }

  // 옵션 그룹 등록 (사이즈,두께 등)
  const groupQuery =
    'INSERT INTO product_option_group (product_id, name) VALUES (?, ?)';
  connection.query(groupQuery, [productId, name], (err, result) => {
    if (err) {
      console.error('옵션 그룹 등록 에러:', err.message);
      return res.status(500).send('옵션 그룹 등록 실패');
    }

    const groupId = result.insertId;

    // 옵션 값 여러개 등록 (200x300mm 값 등)
    const valueQuery =
      'INSERT INTO product_option_value (product_option_group_id, value) VALUES ?';
    const valueData = values.map((v) => [groupId, v]);

    connection.query(valueQuery, [valueData], (err2) => {
      if (err2) {
        console.error('옵션 항목 등록 에러:', err2.message);
        return res.status(500).send('옵션 항목 등록 실패');
      }

      res.status(201).json({ message: '옵션 등록 성공', group_id: groupId });
    });
  });
});

// /product/:id/options - 제품별 옵션 조회
router.get('/product/:id/options', (req, res) => {
  const productId = req.params.id;

  const groupQuery = `
    SELECT og.product_option_group_id, og.name AS group_name
    FROM product_option_group og
    WHERE og.product_id = ?
  `;

  connection.query(groupQuery, [productId], (err, groups) => {
    if (err) {
      console.error('옵션 그룹 조회 에러:', err.message);
      return res.status(500).send('옵션 그룹 조회 실패');
    }

    if (!groups.length) return res.json([]);

    // 각 그룹에 대해 옵션값도 함께 묶기
    const groupIds = groups.map((g) => g.product_option_group_id);
    const valueQuery = `
      SELECT product_option_group_id, value
      FROM product_option_value
      WHERE product_option_group_id IN (?)
    `;

    connection.query(valueQuery, [groupIds], (err2, values) => {
      if (err2) {
        console.error('옵션 값 조회 에러:', err2.message);
        return res.status(500).send('옵션 값 조회 실패');
      }

      // 그룹별로 value들을 묶기
      const grouped = groups.map((group) => {
        const optionValues = values
          .filter(
            (v) => v.product_option_group_id === group.product_option_group_id
          )
          .map((v) => v.value);

        return {
          group_id: group.product_option_group_id,
          name: group.group_name,
          values: optionValues,
        };
      });

      res.json(grouped);
    });
  });
});

// 수량별 가격 (티어) 조회
router.get('/product/:id/quantity-options', (req, res) => {
  const productId = req.params.id;
  const sql = `
    SELECT 
      min_quantity    AS minQty,
      unit_price      AS unitPrice,
      production_time AS productionTime
    FROM product_price_tier
    WHERE product_id = ?
    ORDER BY min_quantity
  `;
  connection.query(sql, [productId], (err, rows) => {
    if (err) {
      console.error('수량 옵션 조회 실패:', err);
      return res.status(500).json({ error: '수량 옵션 조회 실패' });
    }
    res.json({ productId, tiers: rows });
  });
});

// 선택 계산 api
router.post('/product/:id/calculate', (req, res) => {
  const productId = req.params.id;
  const { quantity } = req.body;
  // 해당 수량에 맞는 티어 하나 가져오기
  const tierSql = `
    SELECT unit_price, production_time 
    FROM product_price_tier
    WHERE product_id = ? AND min_quantity <= ?
    ORDER BY min_quantity DESC
    LIMIT 1
  `;
  connection.query(tierSql, [productId, quantity], (err, tiers) => {
    if (err || !tiers.length)
      return res.status(400).json({ error: '티어 없음' });
    const { unit_price: unitPrice, production_time: productionTime } = tiers[0];

    // 배송비 가져오기
    const shipSql = `SELECT shipping_fee FROM product WHERE product_id = ?`;
    connection.query(shipSql, [productId], (err2, prodRows) => {
      if (err2) return res.status(500).json({ error: '배송비 조회 실패' });
      const shipping = Number(prodRows[0].shipping_fee);

      // 계산
      const supply = unitPrice * quantity;
      const vat = Math.round(supply * 0.1);
      const total = supply + vat + shipping;

      res.json({
        quantity,
        unitPrice,
        productionTime,
        supply,
        vat,
        shipping,
        total,
      });
    });
  });
});

// 수량 티어 일괄 등록/수정
router.post('/product/:id/quantity-options', (req, res) => {
  const productId = req.params.id;
  const { tiers } = req.body; // [{minQty, unitPrice, productionTime}, ...]

  if (!Array.isArray(tiers) || tiers.length === 0) {
    return res.status(400).json({ error: 'tiers 배열이 필요합니다.' });
  }

  // 우선 기존 티어 삭제
  connection.query(
    'DELETE FROM product_price_tier WHERE product_id = ?',
    [productId],
    (err) => {
      if (err) return res.status(500).json({ error: '기존 삭제 실패' });

      // 새로 받아온 tiers 삽입
      const values = tiers.map((t) => [
        productId,
        t.minQty,
        t.unitPrice,
        t.productionTime,
      ]);
      const insertSql = `
        INSERT INTO product_price_tier
          (product_id, min_quantity, unit_price, production_time)
        VALUES ?
      `;
      connection.query(insertSql, [values], (err2) => {
        if (err2) return res.status(500).json({ error: '등록 실패' });
        res.json({ message: '수량 티어 등록 완료', count: tiers.length });
      });
    }
  );
});

router.delete('/product/:id/options', (req, res) => {
  const productId = req.params.id;

  // 1) 그룹ID들 조회
  const selGrpSql = `
    SELECT product_option_group_id
    FROM product_option_group
    WHERE product_id = ?
  `;
  connection.query(selGrpSql, [productId], (err, groups) => {
    if (err) return res.status(500).json({ error: err.message });

    const grpIds = groups.map((g) => g.product_option_group_id);
    if (grpIds.length === 0) {
      return res.status(200).json({ message: '삭제할 옵션이 없습니다.' });
    }

    // 2) 값 먼저 삭제
    const delValSql = `
      DELETE FROM product_option_value
      WHERE product_option_group_id IN (?)
    `;
    connection.query(delValSql, [grpIds], (err2) => {
      if (err2) return res.status(500).json({ error: err2.message });

      // 3) 그룹 삭제
      const delGrpSql = `
        DELETE FROM product_option_group
        WHERE product_id = ?
      `;
      connection.query(delGrpSql, [productId], (err3) => {
        if (err3) return res.status(500).json({ error: err3.message });
        res.status(200).json({ message: '모든 옵션 삭제 완료' });
      });
    });
  });
});

module.exports = router;
