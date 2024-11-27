const express = require("express");
const controller = require("../controllers/postController");
const { authenticateToken } = require("../middleware/auth_middleware");
const router = express.Router();

router.get("/hot", controller.hotPost);
router.get("/", controller.findAllPost);
router.get("/:id", controller.findPostById);
router.post("/", controller.createPost);
router.put("/:id", controller.updatePost);
router.delete("/:id", controller.deletePost);
router.post("/:id/like", authenticateToken, controller.likePost);

module.exports = router;
