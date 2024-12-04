const express = require("express");
const { register, login, refresh, updateUser, checkEmail } = require("../controllers/authController");
const { authenticateToken } = require("../middleware/auth_middleware");

const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.post("/refresh", refresh);
router.post("/init", authenticateToken, updateUser);
router.post("/check-email", checkEmail);

module.exports = router;
