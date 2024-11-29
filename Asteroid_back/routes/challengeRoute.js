const express = require("express");
const { getChallengeList, getChallengeDetails, participateInChallenge, uploadChallengeImage, getMyOngoingChallenges } = require("../controllers/challengeController");
const { authenticateToken } = require("../middleware/auth_middleware");
const multer = require("multer");
const upload = multer({ storage: multer.memoryStorage() });

const router = express.Router();

router.get("/", authenticateToken, getChallengeList);
router.get("/my-ongoing", authenticateToken, getMyOngoingChallenges);
router.get("/:challengeId", authenticateToken, getChallengeDetails);
router.post("/:challengeId/participate", authenticateToken, participateInChallenge);
router.post(
  "/:challengeId/upload",
  authenticateToken,
  upload.single("image"),
  uploadChallengeImage
);

module.exports = router;
