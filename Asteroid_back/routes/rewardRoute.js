const express = require("express");
const { getMyRewards } = require("../controllers/rewardController");
const { authenticateToken } = require("../middleware/auth_middleware");

const router = express.Router();

router.get("/my-rewards", authenticateToken, getMyRewards);

module.exports = router; 