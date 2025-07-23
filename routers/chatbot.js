const express = require('express');
const cors = require('cors');

const router = express.Router();

// 이 라우터에만 CORS (모든 출처, POST/OPTIONS 허용)
router.use(
  cors({
    origin: '*',
    methods: ['POST', 'OPTIONS'],
    credentials: true,
  })
);

// preflight(OPTIONS) 대응
router.options('/', cors());

// POST /chat
router.post('/', async (req, res, next) => {
  try {
    const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';
    const upstream = await fetch(`${apiUrl}/chat`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: req.body.message }),
    });

    if (!upstream.ok) {
      const text = await upstream.text();
      return res.status(upstream.status).send(text);
    }

    const json = await upstream.json();
    return res.json(json);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
