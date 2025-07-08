const express = require('express');
const router = express.Router();
const connection = require('../config/mysql');

// 메뉴 트리 생성 함수
function buildTree(items) {
  const map = {};
  const roots = [];

  items.forEach((item) => {
    map[item.id] = { ...item, sub: [] };
  });

  items.forEach((item) => {
    if (item.parent_id) {
      map[item.parent_id]?.sub.push(map[item.id]);
    } else {
      roots.push(map[item.id]);
    }
  });

  return roots;
}

// GNB 라우트
router.get('/gnb', (req, res) => {
  const query = 'SELECT * FROM gnb_menu ORDER BY depth ASC, sort_order ASC';

  connection.query(query, (err, results) => {
    if (err) return res.status(500).send('메뉴 조회 실패');
    const menuTree = buildTree(results);
    res.json(menuTree);
  });
});

module.exports = router;
