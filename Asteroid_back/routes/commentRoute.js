const express = require("express");
const controller = require("../controllers/commentController");
const { authenticateToken } = require("../middleware/auth_middleware");
const router = express.Router();

router.get("/:id", controller.findCommentById);
router.post("/", authenticateToken, controller.createComment);
router.put("/:id", authenticateToken, controller.updateComment);
router.delete("/:id", authenticateToken, controller.deleteComment);
router.post("/:id/like", authenticateToken, controller.likeComment);

module.exports = router;
