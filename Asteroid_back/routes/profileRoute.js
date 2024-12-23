const express = require("express");
const { checkNickname, updateProfile, getProfile } = require("../controllers/profileController");
const { uploadPhotos, saveFilesToDB } = require("../services/fileUploadService");
const { authenticateToken } = require("../middleware/auth_middleware");
const profileService = require('../services/profileService');

const router = express.Router();

// 닉네임 및 좌우명 업데이트
router.post("/update-profile", authenticateToken, updateProfile);
// 프로필 사진 업로드
router.post("/upload-photo", authenticateToken, async (req, res) => {
  try {
    // 파일 업로드 (프로필 사진은 1개만 업로드)
    const file = await uploadPhotos(req, res, 1);

    // 업로드된 파일을 DB에 저장 (User 테이블에 프로필 사진 저장)
    await saveFilesToDB(file, req.user.id, "User");

    return res.status(200).json({
      message: "프로필 사진이 성공적으로 업데이트되었습니다.",
    });
  } catch (error) {
    console.error("프로필 사진 업데이트 오류:", error);
    res.status(500).json({ error: error.message });
  }
});

// 프로필 사진 삭제
router.delete("/delete-photo", authenticateToken, async (req, res) => {
  try {
    await profileService.deleteProfilePhoto(req.user.id);
    res.json({ status: 'success', message: '프로필 사진이 삭제되었습니다.' });
  } catch (error) {
    res.status(500).json({ status: 'error', message: error.message });
  }
});

router.get("/", authenticateToken, getProfile);

module.exports = router;
