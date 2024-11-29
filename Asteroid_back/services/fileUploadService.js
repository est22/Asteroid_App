const multer = require("multer");
const { User, PostImage, BalanceVote, ChallengeImage, Challenge } = require("../models"); // 필요한 테이블들 import

// multer의 메모리 스토리지 사용 (로컬에 저장하지 않고 메모리에서 처리)
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// 여러 파일을 업로드하는 핸들러 (최대 파일 수 제한)
const uploadPhotos = (req, res, maxFiles) => {
  return new Promise((resolve, reject) => {
    const uploadMultiple = upload.array("images", maxFiles); // 최대 파일 수 제한
    uploadMultiple(req, res, function (err) {
      if (err) {
        reject(err); // 에러가 발생하면 reject
      } else {
        // req.files가 undefined인지 체크
        if (!req.files || req.files.length === 0) {
          reject(new Error("파일이 업로드되지 않았습니다."));
        } else if (req.files.length > maxFiles) {
          reject(
            new Error(`최대 ${maxFiles}개의 파일만 업로드할 수 있습니다.`)
          );
        } else {
          resolve(req.files); // 업로드된 파일들이 정상적으로 반환됨
        }
      }
    });
  });
};

// 파일을 DB에 저장하는 함수 (어떤 테이블에 저장할지 선택 가능)
const saveFilesToDB = async (files, userId, targetTable, challengeId) => {
  try {
    const fileRecords = [];

    // 업로드된 파일들 처리
    for (const file of files) {
      const fileBuffer = file.buffer; // 파일의 버퍼 데이터를 가져옵니다 (binary data)
      const fileName = `${Date.now()}-${file.originalname}`; // 파일 이름에 타임스탬프 추가

      // 선택된 테이블에 파일을 저장
      if (targetTable === "User") {
        // 프로필 사진을 User 테이블에 저장 (BYTEA 타입)
        await User.update(
          { profile_picture: fileBuffer }, // profile_picture 필드에 BYTEA 형식으로 저장
          { where: { id: userId } }
        );
      } else if (targetTable === "PostImage") {
        // 게시글 이미지를 PostImage 테이블에 저장 (BYTEA 타입)
        await PostImage.create({
          post_id: userId, // 게시글 ID (사용자 ID 대신 게시글 ID를 저장)
          image_url: fileBuffer, // image_url 필드에 BYTEA 형식으로 저장
          fileName: fileName, // 파일 이름 저장 (옵션)
        });
      } else if (targetTable === "BalanceVote") {
        // 투표용 이미지 저장 (BalanceVote 테이블)
        if (files.length !== 2) {
          throw new Error("투표용 이미지는 2개만 업로드해야 합니다.");
        }
        await BalanceVote.update(
          { image1: files[0].buffer, image2: files[1].buffer }, // 두 이미지 저장
          { where: { userId } }
        );
      } else if (targetTable === "ChallengeImage") {
        const result = await ChallengeImage.create({
          image_url: files[0].buffer,
          user_id: userId,
          challenge_id: challengeId
        });
        return result;
      }

      fileRecords.push({ fileName, fileBuffer }); // 저장된 파일 정보 추가
    }

    return fileRecords; // 저장된 파일 정보 반환
  } catch (error) {
    throw new Error("파일 저장 실패");
  }
};

module.exports = {
  uploadPhotos,
  saveFilesToDB,
};
