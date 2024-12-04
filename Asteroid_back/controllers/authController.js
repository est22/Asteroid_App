const bcrypt = require("bcryptjs");
const userService = require("../services/userService");
const {
  generateAccessToken,
  generateRefreshToken,
} = require("../utils/token.js");
const jwt = require("jsonwebtoken");

const refresh = (req, res) => {
  const { token } = req.body;
  if (!token) return res.sendStatus(401);
  jwt.verify(token, "refresh_secret", (err, user) => {
    if (err) return res.sendStatus(403);

    const accessToken = generateAccessToken(user);
    res.json(accessToken);
  });
};

const login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await userService.findUserByEmail(email);
    if (!user) {
      return res
        .status(400)
        .json({ message: "존재하지 않는 사용자입니다. 이메일을 다시 확인해주세요." });
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res
        .status(400)
        .json({ message: "비밀번호가 일치하지 않습니다." });
    }
    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);
    res.json({
      accessToken,
      refreshToken,
      isProfileSet: user.nickname !== null && user.motto !== null
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const register = async (req, res) => {
  const { email, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    const user = await userService.createUser({
      email: email,
      password: hashedPassword,
    });
    res.status(201).json({ data: user });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 최초 로그인 시 프로필(닉네임, 소비좌우명) 설정
const updateUser = async (req, res) => {
  const { nickname, motto } = req.body;
  const userId = req.user.id;

  try {
    // 닉네임 유효성 검사
    const isValidNickname = /^[A-Za-z0-9가-힣]+$/;  // 한글, 영어, 숫자만 가능
    const containsInvalidHangul = /([ㄱ-ㅎㅏ-ㅣ])/;  // 한글 단일 자음과 모음 제외
    const nicknameLengthInBytes = Buffer.byteLength(nickname, "utf8");

    if (!isValidNickname.test(nickname)) {
      return res.status(400).json({
        message: "닉네임은 한글/영어/숫자만 사용할 수 있습니다."
      });
    }

    if (containsInvalidHangul.test(nickname)) {
      return res.status(400).json({
        message: "단일 자음이나 모음은 닉네임에 사용할 수 없습니다."
      });
    }

    if (nicknameLengthInBytes > 18) {
      return res.status(400).json({
        message: "닉네임은 한글 6글자(영어 12글자) 이하로 입력해주세요."
      });
    }

    // motto 길이 검사 추가
    if (motto.length > 30) {
      return res.status(400).json({
        message: "좌우명은 30글자 이하로 입력해주세요."
      });
    }

    const data = { nickname, motto };
    const updatedUser = await userService.updateUser(userId, data);
    
    if (updatedUser[0] === 0) {
      return res.status(404).json({ 
        message: "사용자를 찾을 수 없습니다." 
      });
    }
    
    res.status(200).json({ 
      message: "프로필이 성공적으로 업데이트되었습니다.", 
      data: updatedUser 
    });
    
  } catch (e) {
    if (e.name === "SequelizeUniqueConstraintError") {
      return res.status(400).json({
        message: "이미 사용 중인 닉네임입니다."
      });
    }
    res.status(500).json({ message: e.message });
  }
};

// 이메일 중복 체크 함수 추가
const checkEmail = async (req, res) => {
    const { email } = req.body;
    try {
        const user = await userService.findUserByEmail(email);
        if (user) {
            return res.status(400).json({ message: "이메일이 중복됩니다." });
        }
        res.status(200).json({ message: "사용 가능한 이메일입니다." });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};

module.exports = {
  register,
  login,
  refresh,
  updateUser,
  checkEmail,  // 추가
};
