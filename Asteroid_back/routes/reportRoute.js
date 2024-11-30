const express = require("express");
const router = express.Router();

const { report } = require("../controllers/reportController");
const { authenticateToken } = require("../middleware/auth_middleware");

router.post("/", authenticateToken, report);

module.exports = router;