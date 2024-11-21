const express = require("express");
const commentController = require("../controllers/commentController");
const router = express.Router();

router.get("/:id", commentController.findCommentById);
router.post("/", commentController.createComment);
router.put("/:id", commentController.updateComment);
router.delete("/:id", commentController.deleteComment);

module.exports = router;
