const express = require("express");
const controller = require("../controllers/postController");
const { authenticateToken } = require("../middleware/auth_middleware");
const upload = require("../middleware/fileUpload_middleware"); // multer 설정 파일 import
const router = express.Router();

router.get("/hot", controller.hotPost);
router.get("/", controller.findAllPost);
router.get("/:id", controller.findPostById);
router.post(
  "/",
  authenticateToken,
  upload.array("images", 10),
  controller.createPost
);
router.put(
  "/:id",
  authenticateToken,
  upload.array("images", 10),
  controller.updatePost
);
router.delete("/:id", authenticateToken, controller.deletePost);
router.post("/:id/like", authenticateToken, controller.likePost);

module.exports = router;
