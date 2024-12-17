const express = require("express");
const controller = require("../controllers/balanceVoteController");
const { authenticateToken } = require("../middleware/auth_middleware");
const upload = require("../middleware/fileUpload_middleware"); // multer 설정 파일 import
const router = express.Router();

router.get("/", controller.findAllVote);
router.post(
  "/",
  authenticateToken,
  upload.array("images", 2),
  controller.createVote
);
router.delete("/:id", authenticateToken, controller.deleteVote);
router.post("/submit/:id", authenticateToken, controller.submitVote);

module.exports = router;
