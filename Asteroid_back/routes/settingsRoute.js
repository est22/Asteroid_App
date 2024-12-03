const express = require("express");
const controller = require("../controllers/settingsController");
const { authenticateToken } = require("../middleware/auth_middleware");
const router = express.Router();

// 내 보상
router.get("/rewards", authenticateToken, controller.getMyRewards);

// 내 진행중인 챌린지
router.get("/challenges", authenticateToken, controller.getMyOngoingChallenges);

// 내 게시글 (게시글 + 밸런스 투표)
router.get("/posts", authenticateToken, controller.getMyPosts);

// 내 댓글
router.get("/comments", authenticateToken, controller.getMyComments);

// 내 쪽지
router.get("/messages", authenticateToken, controller.getMyMessages);

// 내가 좋아요 한 게시물
router.get("/liked-posts", authenticateToken, controller.getMyLikedPosts);

module.exports = router;
