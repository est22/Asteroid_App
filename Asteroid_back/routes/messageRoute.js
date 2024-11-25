const express = require("express");
const controller = require("../controllers/messageController");
const { authenticateToken } = require("../middleware/auth_middleware");
const router = express.Router();

router.get("/", authenticateToken, controller.messageRoom);
router.get("/detail", authenticateToken, controller.findMessageDetail);
router.post("/", controller.createMessage);
router.post("/left", authenticateToken, controller.leftMessage);

module.exports = router;
