const jwt = require("jsonwebtoken");

// 사용자 인증을 위한 용도
const generateAccessToken = (user) => {
  return jwt.sign(
    {
      id: user.id,
      email: user.email,
    },
    "access_secret",
    { expiresIn: "8h" }
  );
};

// accessToken을 발급받기 위한 용도
const generateRefreshToken = (user) => {
  return jwt.sign(
    {
      id: user.id,
      email: user.email,
    },
    "refresh_secret",
    { expiresIn: "14d" }
  );
};

// 비밀번호 재설정을 위한 인증 코드 생성 (JWT)
const generateAuthCodeToken = (email) => {
  // 인증 코드로 사용할 JWT 생성, 이메일만 담아 인증 코드를 유효하게 만듬
  const authCode = Math.floor(100000 + Math.random() * 900000).toString();
  return jwt.sign(
    {
      email: email,
      authCode: authCode,
    },
    "auth_code_secret", // 인증 코드용 비밀키
    { expiresIn: "15m" } // 인증 코드 유효 기간 15분
  );
};


module.exports = {
  generateAccessToken,
  generateRefreshToken,
  generateAuthCodeToken,
};
