const {
  Report,
  User,
  Post,
  Comment,
  ChallengeImage,
} = require("../models");

// 공통 함수: 신고 대상의 user_id와 challenge_id를 가져오는 로직
const getReportedUserId = async (target_type, target_id) => {
  switch (target_type) {
    case "P": {
      const post = await Post.findByPk(target_id);
      if (!post) throw new Error("게시글을 찾을 수 없습니다.");
      return post.user_id; // 게시글 작성자 ID
    }
    case "C": {
      const comment = await Comment.findByPk(target_id);
      if (!comment) throw new Error("댓글을 찾을 수 없습니다.");
      return comment.user_id; // 댓글 작성자 ID
    }
    case "U": {
      const user = await User.findByPk(target_id);
      if (!user) throw new Error("유저를 찾을 수 없습니다.");
      return user.id; // 직접 유저 ID
    }
    case "L": {
      console.log("\n=== 챌린지 이미지 신고 처리 ===");
      console.log("찾으려는 이미지 ID:", target_id);
      
      const challengeImage = await ChallengeImage.findByPk(target_id);
      if (!challengeImage) {
          console.log("이미지를 찾을 수 없음");
          throw new Error("챌린지 이미지를 찾을 수 없습니다.");
      }
      
      console.log("찾은 이미지 정보:", {
          id: challengeImage.id,
          user_id: challengeImage.user_id,
          challenge_id: challengeImage.challenge_id
      });
      
      // user_id가 없는 경우 에러 처리
      if (!challengeImage.user_id) {
          throw new Error("이미지 업로더 정보를 찾을 수 없습니다.");
      }
      
      // 이전 방식으로 객체 반환
      return {
          user_id: challengeImage.user_id,
          challenge_id: challengeImage.challenge_id
      };
    }
    default:
      throw new Error("올바르지 않은 신고 대상입니다.");
  }
};

const report = async (req, res) => {
  const { target_type, target_id, report_type, report_reason } = req.body;
  const reportingUserId = req.user.id; // 신고를 한 유저의 ID

  try {
    // 신고 대상 정보 가져오기
    const result = await getReportedUserId(target_type, target_id);

    let reportedUserId;

    if (target_type === "L") {
      reportedUserId = result.user_id;  // 객체에서 user_id 추출
    } else {
      reportedUserId = result;
    }

    // console.log("Reporting User ID:", reportingUserId); // 디버그: 신고한 유저
    // console.log("Reported User ID:", reportedUserId); // 디버그: 신고 당한 유저

    // 중복 신고 방지
    const existingReport = await Report.findOne({
      where: {
        reporting_user_id: reportingUserId,
        target_type,
        target_id,
        report_type,
      },
    });
    if (existingReport) {
      return res.status(400).json({ message: "이미 신고한 대상입니다." });
    }

    // report_type이 9(기타)일 때만 신고 사유 확인
    if (report_type === 9 && !report_reason) {
      return res.status(400).json({
        message: "신고 사유가 필수입니다. 상세한 신고 사유를 작성해주세요.",
      });
    }

    // 신고 데이터 생성
    const reportData = await Report.create({
      reporting_user_id: reportingUserId,
      target_user_id: reportedUserId,
      target_type,
      target_id,
      report_reason: report_type === 9 ? report_reason : null,
      report_type,
    });

    // 신고 처리 로직: 신고받은 유저의 정지 처리
    const reportedUser = await User.findByPk(reportedUserId);
    if (reportedUser) {
      reportedUser.reported_count += 1;

      // 특정 타입의 신고는 즉시 정지 처리
      const immediateSuspendTypes = [0, 1, 4, 6, 7, 8];
      if (immediateSuspendTypes.includes(report_type)) {
        console.log("Suspending reported user:", reportedUserId); // 디버그: 정지되는 유저 확인
        reportedUser.status = "S"; // 정지 상태로 변경
      } else if (reportedUser.reported_count >= 3) {
        reportedUser.status = "S"; // 신고 누적 3회 이상 시 정지
      }

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
