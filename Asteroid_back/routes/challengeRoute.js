const express = require("express");
const { getChallengeList, getChallengeDetails, participateInChallenge, uploadChallengeImage } = require("../controllers/challengeController");
const { authenticateToken } = require("../middleware/auth_middleware");
const multer = require("multer");
const upload = multer({ storage: multer.memoryStorage() });

const router = express.Router();

router.get("/", authenticateToken, getChallengeList);
router.get("/:challengeId", authenticateToken, getChallengeDetails);
router.post("/:challengeId/participate", authenticateToken, participateInChallenge);
router.post(
  "/:challengeId/upload",
  authenticateToken,
  upload.single("image"), // 'image'라는 필드명으로 단일 파일 업로드 허용
  uploadChallengeImage
);

module.exports = router;
