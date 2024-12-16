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
      return res.status(400).json({
        message: "존재하지 않는 사용자입니다. 이메일을 다시 확인해주세요.",
      });
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "비밀번호가 일치하지 않습니다." });
    }
    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);
    res.json({
      accessToken,
      refreshToken,
      isProfileSet: user.nickname !== null && user.motto !== null,
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
    // motto 길이 검사
    if (motto.length > 30) {
      return res.status(400).json({
        message: "좌우명은 30글자 이하로 입력해주세요.",
      });
    }
    try {
      // motto 길이 검사
      if (motto.length > 30) {
        return res.status(400).json({
          message: "좌우명은 30글자 이하로 입력해주세요.",
        });
      }

      const data = { nickname, motto };
      const updatedUser = await userService.updateUser(userId, data);

      if (updatedUser[0] === 0) {
        return res.status(404).json({
          message: "사용자를 찾을 수 없습니다.",
        });
      }

      res.status(200).json({
        message: "프로필이 성공적으로 업데이트되었습니다.",
        data: updatedUser,
      });
    } catch (e) {
      if (e.name === "SequelizeUniqueConstraintError") {
        return res.status(400).json({
          message: "이미 사용 중인 닉네임입니다.",
        });
      }
      res.status(500).json({ message: e.message });
    }
    const data = { nickname, motto };
    const updatedUser = await userService.updateUser(userId, data);

    if (updatedUser[0] === 0) {
      return res.status(404).json({
        message: "사용자를 찾을 수 없습니다.",
      });
    }

    res.status(200).json({
      message: "프로필이 성공적으로 업데이트되었습니다.",
      data: updatedUser,
    });
  } catch (e) {
    if (e.name === "SequelizeUniqueConstraintError") {
      return res.status(400).json({
        message: "이미 사용 중인 닉네임입니다.",
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

const appleLogin = async (req, res) => {
  const { apple_id, email } = req.body;

  console.log("애플 로그인 요청:", { apple_id, email }); // 요청 데이터 로깅

  try {
    // apple_id로 기존 사용자 찾기
    let user = await userService.findUserByAppleId(apple_id);
    console.log("기존 사용자 검색 결과:", user); // 기존 사용자 검색 결과 로깅

    if (!user) {
      console.log("새 사용자 생성 시도"); // 새 사용자 생성 시도 로깅
      try {
        user = await userService.createAppleUser({
          apple_id: apple_id,
          email: email || null,
        });
        console.log("새 사용자 생성 성공:", user); // 생성된 사용자 정보 로깅
      } catch (createError) {
        console.error("사용자 생성 실패:", createError); // 생성 실패 시 에러 로깅
        throw createError;
      }
    } else if (email && !user.email) {
      console.log("기존 사용자 이메일 업데이트 시도"); // 이메일 업데이트 시도 로깅
      user.email = email;
      await user.save();
      console.log("이메일 업데이트 성공");
    }

    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);

    console.log("토큰 생성 완료"); // 토큰 생성 완료 로깅

    res.json({
      accessToken,
      refreshToken,
      isProfileSet: user.nickname !== null && user.motto !== null,
    });
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

// 닉네임 중복 체크 함수 추가
const checkNickname = async (req, res) => {
  const { nickname } = req.body;

  try {
    // 닉네임 유효성 검사
    const isValidNickname = /^[A-Za-z0-9가-힣]+$/; // 한글, 영어, 숫자만 가능
    const containsInvalidHangul = /([ㄱ-ㅎㅏ-ㅣ])/; // 한글 단일 자음과 모음 제외
    const nicknameLengthInBytes = Buffer.byteLength(nickname, "utf8");

    if (!isValidNickname.test(nickname)) {
      return res.status(400).json({
        message: "닉네임은 한글/영어/숫자만 사용할 수 있습니다.",
      });
    }

    if (containsInvalidHangul.test(nickname)) {
      return res.status(400).json({
        message: "단일 자음이나 모음은 닉네임에 사용할 수 없습니다.",
      });
    }

    if (nicknameLengthInBytes > 18) {
      return res.status(400).json({
        message: "닉네임은 한글 6글자(영어 12글자) 이하로 입력해주세요.",
      });
    }

    const existingUser = await userService.findUserByNickname(nickname);
    if (existingUser) {
      return res.status(400).json({ message: "이미 사용 중인 닉네임입니다." });
    }
    res.status(200).json({ message: "사용 가능한 닉네임입니다." });
  } catch (e) {
    console.error("닉네임 체크 에러:", e); // 에러 로깅 추가
    res.status(500).json({ message: e.message });
  }
};

const kakaoLogin = async (req, res) => {
  const { kakao_id } = req.body;

  console.log("카카오 로그인 요청:", { kakao_id });

  try {
    let user = await userService.findUserByKakaoId(kakao_id);
    console.log("기존 사용자 검색 결과:", user);

    if (!user) {
      console.log("새 사용자 생성 시도");
      try {
        user = await userService.createKakaoUser({
          kakao_id: kakao_id,
        });
        console.log("새 사용자 생성 성공:", user);
      } catch (createError) {
        console.error("사용자 생성 실패:", createError);
        throw createError;
      }
    }

    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);

    console.log("토큰 생성 완료");

    // LoginResponse 형식에 맞춰 응답
    res.json({
      accessToken: accessToken,
      refreshToken: refreshToken,
      isProfileSet: Boolean(user.nickname && user.motto),
    });
  } catch (e) {
    console.error("카카오 로그인 에러:", e);
    res.status(500).json({
      message: "카카오 로그인 처리 중 오류가 발생했습니다.",
    });
  }
};

module.exports = {
  register,
  login,
  refresh,
  updateUser,
  checkEmail,
  appleLogin,
  kakaoLogin,
  checkNickname,
};
