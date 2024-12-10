const express = require("express");
const { register, login, refresh, updateUser, checkEmail, appleLogin, checkNickname } = require("../controllers/authController");
const { authenticateToken } = require("../middleware/auth_middleware");

const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.post("/refresh", refresh);
router.post("/init", authenticateToken, updateUser);
router.post("/check-email", checkEmail);
router.post("/apple-login", appleLogin);
router.post("/check-nickname", authenticateToken, checkNickname);

module.exports = router;
