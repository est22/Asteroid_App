const express = require("express");
const postController = require("../controllers/postController");
const { authenticateToken } = require("../middleware/auth_middleware");
const router = express.Router();

router.get("/hot", postController.hotPost);
router.get("/", postController.findAllPost);
router.get("/:id", postController.findPostById);
router.post("/", postController.createPost);
router.put("/:id", postController.updatePost);
router.delete("/:id", postController.deletePost);
router.post("/:id/like", authenticateToken, postController.likePost);

module.exports = router;
