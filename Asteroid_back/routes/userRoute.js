const express = require("express");
const { updateDeviceToken } = require("../controllers/userController");
const { authenticateToken } = require("../middleware/auth_middleware");

const router = express.Router();

router.post("/device-token", authenticateToken, updateDeviceToken);

module.exports = router;


