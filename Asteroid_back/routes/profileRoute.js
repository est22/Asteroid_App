const express = require("express");
const { checkNickname, updateProfile } = require("../controllers/profileController");
const { authenticateToken } = require("../middleware/auth_middleware");

const router = express.Router();

// 닉네임 중복 검사
router.post("/check-nickname", authenticateToken, checkNickname);
// 닉네임 및 좌우명 업데이트
router.post("/update-profile", authenticateToken, updateProfile);
module.exports = router;
