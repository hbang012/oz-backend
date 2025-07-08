// oz-backend/routers/upload.js
const express = require('express');
const multer = require('multer');
const path = require('path');
const router = express.Router();

// public/images 폴더에 저장
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, '../public/images'));
  },
  filename: (req, file, cb) => {
    const filename = `${Date.now()}-${file.originalname}`;
    cb(null, filename);
  },
});
const upload = multer({ storage });

// POST /upload → 파일 하나 업로드
router.post('/', upload.single('file'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: '파일이 없습니다.' });
  }
  // 리턴되는 URL을 프론트에 전달
  res.status(201).json({
    thumbnail_url: `/images/${req.file.filename}`,
  });
});

module.exports = router;
