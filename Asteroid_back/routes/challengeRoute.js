const express = require("express");
const { getChallengeList, getChallengeDetails, participateInChallenge, uploadChallengeImage, getMyOngoingChallenges } = require("../controllers/challengeController");
const { authenticateToken } = require("../middleware/auth_middleware");
const router = express.Router();

router.get("/", authenticateToken, getChallengeList);
router.get("/my-ongoing", authenticateToken, getMyOngoingChallenges);
router.get("/:challengeId", authenticateToken, getChallengeDetails);
router.post("/:challengeId/participate", authenticateToken, participateInChallenge);
router.post("/:challengeId/upload", authenticateToken, uploadChallengeImage);

module.exports = router;
