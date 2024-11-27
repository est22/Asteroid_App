const { User, Report } = require("../models");

const restrictActions = async (req, res, next) => {
  const userId = req.user.id;

  try {
    const user = await User.findByPk(userId);

    if (!user)
      return res.status(404).json({ message: "사용자를 찾을 수 없습니다." });

    // 상태가 "S"인 경우 요청 차단
    if (user.status === "S") {
      return res.status(403).json({ message: "이용이 정지된 사용자입니다." });
    }

    // Report 테이블에서 특정 타입에 대한 신고 확인 (target_user_id 기준)
    const restrictedTypes = [0, 1, 4, 6, 7, 8];
    const reports = await Report.findAll({
      where: { target_user_id: userId, report_type: restrictedTypes },
    });

    if (reports.length > 0) {
      return res.status(403).json({
        message: "신고로 인해 글쓰기 또는 댓글 작성이 제한되었습니다.",
      });
    }

    next(); // 제한 조건이 없으면 요청 진행
  } catch (error) {
    console.error("RestrictActions 미들웨어 오류:", error);
    res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

module.exports = restrictActions;
