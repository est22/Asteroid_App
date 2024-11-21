const profileService = require("../services/profileService");
const {handleMultipleFileUpload, saveFilesToDB} = require("../services/fileUploadService");

const checkNickname = async (nickname, userId) =>{

    try {
      // 1. 닉네임 중복 검사
      const existingUser = await profileService.findUserByNickname(
        nickname,
        userId
      );
      if (existingUser) {
        throw new Error("닉네임 중복");
      }

      // 2. 닉네임 글자 수 검사
      const isValidNickname = /^[A-Za-z0-9가-힣ㄱ-ㅎㅏ-ㅣ]+$/; // 한글, 영어, 숫자만 가능, 단일 자음/모음 제외
      const containsInvalidHangul = /([ㄱ-ㅎㅏ-ㅣ])/; // 한글 단일 자음과 모음 제외
      const nicknameLengthInBytes = Buffer.byteLength(nickname, "utf8"); // 문자열을 UTF-8로 인코딩한 후 바이트 크기 계산

      if (!isValidNickname.test(nickname)) {
        throw new Error(
          "닉네임은 한글, 영어, 숫자만 사용할 수 있습니다. 공백과 단일 자음/모음은 불가능합니다."
        );
      }

      if (containsInvalidHangul.test(nickname)) {
        throw new Error("단일 자음이나 모음은 닉네임에 사용할 수 없습니다.");
      }

      if (nicknameLengthInBytes > 18) {
        throw new Error(
          "닉네임은 한글 6글자, 영어 12글자 이하로 입력해주세요."
        );
      }

      return "닉네임 사용 가능";
    } catch (e) {
    console.error("Error:", e); // 오류 상세히 출력
    throw e;
  }
};
 
const checkMottoLength = (motto) => {
  const mottoLengthInBytes = Buffer.byteLength(motto, "utf8"); // 문자열을 UTF-8로 인코딩한 후 바이트 크기 계산
  if (mottoLengthInBytes > 100) {
    throw new Error("좌우명을 30여자로 입력해주세요.");
  }
};

const updateProfile = async (req, res) => {
  console.log("User Info:", req.user); // req.user 출력 (debug)
  console.log("first Request Body:", req.body); // debug

  const { nickname, motto } = req.body;
  const userId = req.user?.id;

  if (!userId) {
    return res.status(400).json({ error: "사용자 ID가 존재하지 않습니다." });
  }

  try {
    // 업데이트 데이터 생성
    const updatedData = {};
    // 닉네임 업데이트 요청 시 중복 검사
    if (nickname) {
      try {
        const nicknameCheckResult = await checkNickname(nickname, userId);
        if (nicknameCheckResult !== "닉네임 사용 가능") {
          return res.status(400).json({ message: nicknameCheckResult });
        }
        updatedData.nickname = nickname;
      } catch (e) {
        if (e.message === "닉네임 중복") {
          return res.status(400).json({ message: "닉네임 중복" });
        }
        throw e; // 다른 오류가 발생한 경우 다시 던짐
      }
    }

    // motto가 있을 경우, 글자수 검사
    if (motto) {
      checkMottoLength(motto);
      updatedData.motto = motto;
    }

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

// 프로필 사진 업로드 처리
const uploadProfilePhoto = async (req, res) => {
  try {
    // 파일 업로드 처리 (1개만 허용)
    const files = await handleMultipleFileUpload(req, res, 1); // 최대 1개 파일

    // DB에 프로필 사진 저장
    const result = await saveFilesToDB(files, req.user.id, "User");

    return res.status(200).json({
      message: "프로필 사진이 성공적으로 업로드되었습니다.",
      data: result,
    });
  } catch (e) {
    console.error("Error:", e);
    res.status(400).json({ error: e.message });
  }
};

module.exports = {
  checkNickname,
  updateProfile,
  uploadProfilePhoto
};
