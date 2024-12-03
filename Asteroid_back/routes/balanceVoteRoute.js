const express = require("express");
const multer = require("multer");
const controller = require("../controllers/balanceVoteController");
const { authenticateToken } = require("../middleware/auth_middleware");
const router = express.Router();
const upload = multer();

router.get("/", controller.findAllVote);
router.post(
  "/",
  authenticateToken,
  upload.array("images"),
  controller.createVote
);
router.put(
  "/:id",
  authenticateToken,
  upload.array("images"),
  controller.updateVote
);
router.delete("/:id", authenticateToken, controller.deleteVote);
router.post("/:id/submit", authenticateToken, controller.submitVote);

module.exports = router;
