const express = require("express");
const authRoute = require("./routes/authRoute");  // 토큰 인증
const postRoute = require("./routes/postRoute");   // 커뮤니티
const balanceVoteRoute = require("./routes/balanceVoteRoute");  // 밸런스투표
const challengeRoute = require("./routes/challengeRoute");  // 챌린지
const settingsRoute = require("./routes/settingsRoute");   // 설정
const messageRoute = require("./routes/messageRoute");   // 쪽지함



const models = require("./models");
const app = express();
const PORT = 3000;

app.use(express.json());
app.use("/auth", authRoute);
app.use("/posts", postRoute);
app.use("/balance", balanceVoteRoute);
app.use("/challenge", challengeRoute);
app.use("/settings", settingsRoute);
app.use("/message", messageRoute);

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
