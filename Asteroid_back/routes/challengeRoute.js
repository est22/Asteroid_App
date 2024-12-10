const express = require("express");
const { getChallengeList, getChallengeDetails, participateInChallenge, uploadChallengeImage, getTopUsersByChallenge, getChallengeImages } = require("../controllers/challengeController");
const { authenticateToken } = require("../middleware/auth_middleware");
const router = express.Router();

router.get("/", authenticateToken, getChallengeList);
router.get("/ranking", authenticateToken, getTopUsersByChallenge);
router.get("/:challengeId", authenticateToken, getChallengeDetails);
router.post("/:challengeId/participate", authenticateToken, participateInChallenge);
router.post("/:challengeId/upload", authenticateToken, uploadChallengeImage);
router.get("/:challengeId/images", authenticateToken, getChallengeImages);

module.exports = router;
