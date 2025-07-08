const express = require('express');
const router = express.Router();
const connection = require('../config/mysql');

// GET/blog → 전체 글 목록 조회
router.get('/', (req, res) => {
  connection.query(
    'SELECT * FROM blog_posts ORDER BY created_at DESC',
    (err, rows) => {
      if (err) {
        console.error('블로그 목록 조회 에러:', err);
        return res.status(500).json({ error: 'DB 조회 실패' });
      }
      res.json(rows);
    }
  );
});

// GET/blog/:id → 단일 글 조회
router.get('/:id', (req, res) => {
  const { id } = req.params;
  connection.query(
    'SELECT * FROM blog_posts WHERE post_id = ?',
    [id],
    (err, rows) => {
      if (err) {
        console.error('블로그 단일 조회 에러:', err);
        return res.status(500).json({ error: 'DB 조회 실패' });
      }
      if (rows.length === 0) return res.status(404).json({ error: '글 없음' });
      res.json(rows[0]);
    }
  );
});

// POST/blog → 새 글 작성
router.post('/', (req, res) => {
  const { title, description } = req.body;
  let thumbnail_url = req.body.thumbnail_url;
  if (!title || !description) {
    return res
      .status(400)
      .json({ error: '필수 필드(title, description) 누락' });
  }

  // 기본 썸네일
  if (!thumbnail_url) {
    thumbnail_url = '/images/focus-00.png';
  }

  const sql = `
    INSERT INTO blog_posts
      (title, description, thumbnail_url)
    VALUES (?, ?, ?)
  `;
  connection.query(sql, [title, description, thumbnail_url], (err, result) => {
    if (err) {
      console.error('블로그 작성 에러:', err);
      return res.status(500).json({ error: 'DB 삽입 실패' });
    }
    res.status(201).json({
      message: '작성 성공',
      post_id: result.insertId,
    });
  });
});

// PUT/blog/:id → 글 수정
router.put('/:id', (req, res) => {
  const { id } = req.params;
  const { title, description, thumbnail_url } = req.body;
  if (!title || !description || !thumbnail_url) {
    return res
      .status(400)
      .json({ error: '필수 필드(title, description, thumbnail_url) 누락' });
  }

  const sql = `
    UPDATE blog_posts
       SET title         = ?,
           description   = ?,
           thumbnail_url = ?,
           updated_at    = NOW()
     WHERE post_id = ?
  `;
  connection.query(
    sql,
    [title, description, thumbnail_url, id],
    (err, result) => {
      if (err) {
        console.error('블로그 수정 에러:', err);
        return res.status(500).json({ error: 'DB 수정 실패' });
      }
      if (result.affectedRows === 0)
        return res.status(404).json({ error: '글 없음' });
      res.json({ message: '수정 성공' });
    }
  );
});

// DELETE /blog/:id  → 글 삭제
router.delete('/:id', (req, res) => {
  const { id } = req.params;
  connection.query(
    'DELETE FROM blog_posts WHERE post_id = ?',
    [id],
    (err, result) => {
      if (err) {
        console.error('블로그 삭제 에러:', err);
        return res.status(500).json({ error: 'DB 삭제 실패' });
      }
      if (result.affectedRows === 0)
        return res.status(404).json({ error: '글 없음' });
      res.json({ message: '삭제 성공' });
    }
  );
});

module.exports = router;
