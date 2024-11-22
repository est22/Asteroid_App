const bcrypt = require("bcryptjs");
const nodemailer = require("nodemailer");
require("dotenv").config(); 
const userService = require("../services/userService");
const { generateAccessToken,generateRefreshToken, generateAuthCodeToken} = require("../utils/token.js");
const jwt = require("jsonwebtoken");

const refresh = (req, res) => {
  const { token } = req.body;
  if (!token) return res.sendStatus(401);
  jwt.verify(token, "refresh_secret", (err, user) => {
    if (err) return res.sendStatus(403);

    const accessToken = generateAccessToken(user);
    res.json(accessToken);
  });
};

const login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await userService.findUserByEmail(email);
    if (!user) {
      return res
        .status(400)
        .json({ message: "No user: Invalid email or password" });
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res
        .status(400)
        .json({ message: "Not matching: Invalid email or password" });
    }
    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);
    res.json({
      accessToken,
      refreshToken,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const register = async (req, res) => {
  const { email, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    const user = await userService.createUser({
      email: email,
      password: hashedPassword,
    });
    res.status(201).json({ data: user });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 최초 로그인 시 프로필(닉네임, 소비좌우명) 설정
const updateUser = async (req, res) => {
  const { nickname, motto } = req.body;
  const userId = req.user.id; // Users 테이블에서 유저id를 가져옴

  // 로그 추가 for debug
  console.log("Received nickname:", nickname);
  console.log("Received motto:", motto);
  console.log("User ID:", userId); // userId가 올바르게 설정되었는지 확인

  const data = { nickname, motto };

  try {
    const updatedUser = await userService.updateUser(userId, data);
    if (updatedUser[0] === 0) {
      return res
        .status(404)
        .json({ message: "User not found or no changes made" });
    }
    res
      .status(200)
      .json({ message: "Profile updated successfully", data: updatedUser });
  } catch (e) {
    // 고유 제약 조건 에러 (닉네임 중복)
    if (e.name === "SequelizeUniqueConstraintError") {
      return res
        .status(400)
        .json({
          message: "닉네임이 중복됩니다. 다른 닉네임을 사용하세요.",
        });
    }

    // 그 외의 서버 오류
    console.error("Error:", e); // 오류 상세히 출력
    res.status(500).json({ error: e.message });
  }
};

// 이메일로 인증 코드 발송
const forgotPassword = async (req, res) => {
  const { email } = req.body;

  try {
    // 이메일로 사용자 확인
    const user = await userService.findUserByEmail(email);
    if (!user) return res.status(400).json({ message: "해당 이메일이 존재하지 않습니다." });

    // JWT를 통해 인증 코드 생성
    const authCodeToken = generateAuthCodeToken(email);

    // 인증 코드 이메일 발송
    const transporter = nodemailer.createTransport({
      service: "Gmail",
      auth: {
        user: process.env.ADMIN_EMAIL,
        pass: process.env.ADMIN_PASSWORD,
      },
    });

    const mailOptions = {
      from: process.env.ADMIN_EMAIL,
      to: email,
      subject: "비밀번호 인증 코드",
      text: `비밀번호 재설정을 위한 인증 코드는 \n[${authCodeToken}]입니다.`, // JWT 토큰을 이메일로 전송
    };

    await transporter.sendMail(mailOptions);

    // 인증 코드 발송 성공
    res.status(200).json({ message: "인증번호가 메일로 발송되었습니다." });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// 인증 코드 확인
const verifyCode = async (req, res) => {
  const { email, authCodeToken } = req.body;

  try {
    // JWT 인증 코드 확인
    jwt.verify(authCodeToken, "auth_code_secret", (err, decoded) => {
      if (err || decoded.email !== email) {
        return res.status(400).json({ message: "잘못된 인증번호입니다." });
      }
      res.status(200).json({ message: "인증되었습니다." });
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// 새 비밀번호 설정
const resetPassword = async (req, res) => {
  const { email, newPassword, authCodeToken } = req.body;

  try {
    // JWT 인증 코드 확인
    jwt.verify(authCodeToken, "auth_code_secret", async (err, decoded) => {
      if (err || decoded.email !== email) {
        return res.status(400).json({ message: "잘못된 인증번호입니다." });
      }

      // 비밀번호 해싱 후 업데이트
      const hashedPassword = await bcrypt.hash(newPassword, 10);
      await userService.updatePassword(email, hashedPassword);

      res.status(200).json({ message: "비밀번호가 정상적으로 재설정되었습니다." });
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  register,
  login,
  refresh,
  updateUser,
  forgotPassword,
  verifyCode,
  resetPassword,
};
