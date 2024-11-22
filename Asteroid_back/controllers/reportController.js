const { Report, User, Post, Comment, Message } = require("../models");

// 공통 함수: 신고 대상의 user_id를 가져오는 로직
const getReportedUserId = async (target_type, target_id) => {
  switch (target_type) {
    case "P": { // Post
      const post = await Post.findByPk(target_id);
      if (!post) throw new Error("게시글을 찾을 수 없습니다.");
      return post.user_id;
    }
    case "C": { // Comment
      const comment = await Comment.findByPk(target_id);
      if (!comment) throw new Error("댓글을 찾을 수 없습니다.");
      return comment.user_id;
    }
    case "U": { // User (from Message Table) (쪽지 유저 신고)
      const user = await User.findByPk(target_id);
      if (!user) throw new Error("유저를 찾을 수 없습니다.");
      return user.id;
    }
    default:
      throw new Error("올바르지 않은 신고 대상입니다.");
  }
};

const report = async (req, res) => {
  const { target_type, target_id, report_type, report_reason } = req.body;
  const userId = req.user.id;

  try {
    // 신고 대상의 user_id 가져오기
    const reportedUserId = await getReportedUserId(target_type, target_id);

    // 중복 신고 방지
    const existingReport = await Report.findOne({
      where: { user_id: userId, target_type, target_id, report_type },
    });
    if (existingReport) {
      return res.status(400).json({ message: "이미 신고한 대상입니다." });
    }

    // report_type이 9(기타)일 때만 신고 사유 확인
    if (report_type === 9 && !report_reason) {
      return res.status(400).json({
        message:
          "신고 사유 '기타'를 선택하셨습니다. 상세한 신고 사유를 작성해주세요.",
      });
    }

    // 신고 데이터 생성
    const reportData = await Report.create({
      user_id: userId,
      target_type,
      target_id,
      report_reason: report_type === 9 ? report_reason : null, // 기타 사유만 저장
      report_type,
    });

    // 신고받은 유저의 신고 횟수 증가
    const reportedUser = await User.findByPk(reportedUserId);
    if (reportedUser) {
      reportedUser.reported_count += 1;
      await reportedUser.save();
    }

    res.status(200).json({
      message: "신고가 성공적으로 접수되었습니다.",
      data: reportData,
    });
  } catch (error) {
    console.error("Error:", error);
    res.status(400).json({ message: error.message });
  }
};

module.exports = {
  report,
};
