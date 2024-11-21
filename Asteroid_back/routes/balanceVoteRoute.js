const express = require("express");
const voteController = require("../controllers/balanceVoteController");
const router = express.Router();

router.get("/", voteController.findAllVote);
router.post("/", voteController.createVote);
router.put("/:id", voteController.updateVote);
router.delete("/:id", voteController.deleteVote);
router.post("/:id/submit", voteController.submitVote);

module.exports = router;
