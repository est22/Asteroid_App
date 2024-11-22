const express = require("express");
const { register, login, refresh, updateUser } = require("../controllers/authController");
const { authenticateToken } = require("../middleware/auth_middleware");
const { forgotPassword, verifyCode, resetPassword} = require("../controllers/authController");

const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.post("/refresh", refresh);
router.post("/init", authenticateToken, updateUser);
router.post("/forgot-password", forgotPassword); // 이메일로 인증 코드 발송
router.post("/verify-code", verifyCode); // 인증 코드 확인
router.post("/reset-password", resetPassword); // 새 비밀번호 설정

module.exports = router;
