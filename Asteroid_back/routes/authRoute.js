const express = require("express");
const { register, login, refresh, updateUser } = require("../controllers/authController");
const { authenticateToken } = require("../middleware/auth_middleware");

const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.post("/refresh", refresh);
router.post("/init", authenticateToken, updateUser);

module.exports = router;
