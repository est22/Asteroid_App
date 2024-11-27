const bcrypt = require("bcryptjs");
const userService = require("../services/userService");
const {
  generateAccessToken,
  generateRefreshToken,
} = require("../utils/token.js");
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
      return res.status(400).json({
        message: "닉네임이 중복됩니다. 다른 닉네임을 사용하세요.",
      });
    }

    // 그 외의 서버 오류
    console.error("Error:", e); // 오류 상세히 출력
    res.status(500).json({ error: e.message });
  }
};

module.exports = {
  register,
  login,
  refresh,
  updateUser,
};
