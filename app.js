// app은 미들웨어 실행용도로만

const express = require('express');
const morgan = require('morgan');
const dotenv = require('dotenv');
const path = require('path');
const cors = require('cors');

// 연결
const productRouter = require('./routers/product');
const productOptionRouter = require('./routers/productOption');
const productPricingRouter = require('./routers/productPricing');
const gnbRouter = require('./routers/gnb');
const blogRouter = require('./routers/blog');
const chatbotRouter = require('./routers/chatbot');

//  dotenv 활성화
dotenv.config();

// 익스프레스 인스턴스 생성
const app = express();
// nextjs가 3000 이므로 포트 변경
app.set('port', process.env.PORT || 3001);

// 미들웨어설정
// 모든 출처에 대해 요청허용
app.use(cors());
app.use(morgan('dev'));

app.use(express.static(path.join(__dirname, 'public')));

app.use(express.json());

app.use(express.urlencoded({ extended: false }));

// 라우터 설정 (불러오기)
app.use(productRouter);
app.use(productOptionRouter);
app.use(productPricingRouter);
app.use(gnbRouter);
app.use('/blog', blogRouter);
app.use('/chat', chatbotRouter);

// 에러처리 미들웨어
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).send(err.message);
});

// 서버 실행
app.listen(app.get('port'), () => {
  console.log(app.get('port'), '번 포트에서 대기중');
});
