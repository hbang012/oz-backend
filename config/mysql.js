// 로컬에 있는 디비에 접속하기
const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '1234',
  database: 'oz_db',
});

connection.connect((err) => {
  if (err) console.error('mysql connection error : ' + err);
  console.log('mysql connected successfully');
});

module.exports = connection;
