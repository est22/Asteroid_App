const profileService = require("../services/profileService");

const checkNickname = async (req, res) => {
    const { nickname } = req.body;
    const userId = req.user?.id;

  try {
    // 닉네임 글자 수 검사
    const nicknameLength = [...nickname].length; // 문자열을 유니코드 문자 배열로 변환 후 길이 계산
    if (nicknameLength > 6) {
      return res
        .status(400)
        .json({ message: "닉네임은 한글 6글자 이하로 입력해주세요." });
    }

    // 닉네임 중복 검사
    const existingUser = await profileService.findUserByNickname(nickname, userId);
      if (existingUser) {
        return res.status(400).json({ message: "닉네임 중복" });
      }

    return res.status(200).json({ message: "닉네임 사용 가능" });
  } catch (e) {
    console.error("Error:", e); // 오류 상세히 출력
    res.status(500).json({ error: e.message });
  }
};


const updateProfile = async (req, res) => {
  const { nickname, motto } = req.body;
  const userId = req.user.id; // `authenticateToken` 미들웨어에서 추출된 사용자 ID

  try {
    // 닉네임 업데이트 요청 시 중복 검사
    if (nickname) {
      const existingUser = await profileService.findUserByNickname(
        nickname,
        userId
      );
      if (existingUser) {
        return res
          .status(400)
          .json({ message: "이미 사용 중인 닉네임입니다." });
      }

      // 닉네임 글자수 검사
      const nicknameLength = [...nickname].length;
      if (nicknameLength > 6) {
        return res
          .status(400)
          .json({ message: "닉네임은 한글 6글자 이하로 입력해주세요." });
      }
    }

    // 업데이트 데이터 생성
    const updatedData = {};
    if (nickname) updatedData.nickname = nickname;
    if (motto) updatedData.motto = motto;

    // 업데이트 수행
    await profileService.updateUserProfile(userId, updatedData);

    return res
      .status(200)
      .json({ message: "프로필이 성공적으로 업데이트되었습니다." });
  } catch (e) {
    console.error("Error:", e);
    res.status(500).json({ error: e.message });
  }
};

module.exports = {
  checkNickname,
  updateProfile,
};
