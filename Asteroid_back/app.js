const express = require("express");
const authRoute = require("./routes/authRoute"); // 토큰 인증
const balanceVoteRoute = require("./routes/balanceVoteRoute"); // 밸런스투표
const challengeRoute = require("./routes/challengeRoute"); // 챌린지
const commentRoute = require("./routes/commentRoute"); // 댓글
const messageRoute = require("./routes/messageRoute"); // 쪽지함
const postRoute = require("./routes/postRoute"); // 커뮤니티
const profileRoute = require("./routes/profileRoute"); // 유저 프로필
const reportRoute = require("./routes/reportRoute"); // 신고
const userRoute = require("./routes/userRoute"); // 유저
const settingsRoute = require("./routes/settingsRoute"); // 설정

const { scheduleChallengeCheck } = require("./services/challengeService"); // 챌린지 달성 체크
const { schedule } = require('node-cron');
const { updateChallengeStatusAndReward } = require('./services/challengeService');

const models = require("./models");
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/auth", authRoute);
app.use("/profile", profileRoute);
app.use("/report", reportRoute);
app.use("/post", postRoute);
app.use("/comment", commentRoute);
app.use("/balance", balanceVoteRoute);
app.use("/challenge", challengeRoute);
scheduleChallengeCheck(); // 서버 시작 시 스케줄러 실행 (챌린지 달성 체크)
app.use("/user", userRoute);
app.use("/settings", settingsRoute);
app.use("/message", messageRoute);

// 매일 자정에 챌린지 상태 업데이트 및 보상 지급 실행
schedule('0 0 * * *', () => {
  updateChallengeStatusAndReward();
});

app.listen(PORT, () => {
  console.log(`Server listening on ${PORT}...`);
  models.sequelize
    .sync({ force: false })
    .then(() => {
      console.log(`DB connected`);
    })
    .catch((err) => {
      console.error(`DB error: ${err}`);
      process.exit();
    });
});
