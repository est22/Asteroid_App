const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Report extends Model {
    static associate(models) {
      Report.belongsTo(models.User, {
        foreignKey: "target_user_id",
        onDelete: "CASCADE",
      });
    }
  }
  Report.init(
    {
      target_user_id: DataTypes.INTEGER, // 신고 대상의 작성자 ID
      reporting_user_id: DataTypes.INTEGER, // 신고한 유저의 ID
      target_type: DataTypes.CHAR(1),
      target_id: DataTypes.INTEGER,
      report_reason: DataTypes.STRING,
      report_type: DataTypes.SMALLINT,
    },
    {
      sequelize,
      modelName: "Report",
      indexes: [
        {
          unique: true,
          fields: ["target_user_id","target_type", "target_id", "report_type"],
        },
      ],
    }
  );
  // 신고 접수 시 User status 변경하는 hook
  Report.addHook("afterCreate", async (report, options) => {
    const { report_type, reporting_user_id, target_type, target_id } = report;

    // 유저 모델 가져오기
    const User = sequelize.models.User;
    const Post = sequelize.models.Post;
    const Comment = sequelize.models.Comment;
    const ChallengeParticipation = sequelize.models.ChallengeParticipation;

    // (1) 신고 대상의 작성자 ID를 가져오기
    let targetUserId = null;

    if (target_type === "P") {
      // target_type이 P인 경우 -> Post 테이블에서 작성자 ID를 가져옴
      const post = await Post.findByPk(target_id);
      if (post) {
        targetUserId = post.user_id; // 게시글의 작성자 ID
      }
    } else if (target_type === "C") {
      // target_type이 C인 경우 -> Comment 테이블에서 작성자 ID를 가져옴 
      const comment = await Comment.findByPk(target_id);
      if (comment) {
        targetUserId = comment.user_id; // 댓글의 작성자 ID
      }
    } else if (target_type === "U") {
      // target_type이 U인 경우 -> User 테이블에서 ID를 그대로 가져옴 
      targetUserId = target_id; // 직접 유저 ID를 사용

    } else if (target_type === "L") {
      const challengeParticipation = await ChallengeParticipation.findByPk(target_id);
      if (challengeParticipation) {
        targetUserId = challengeParticipation.user_id; // 챌린지 참여의 작성자 ID
      }
    }

    // (2) 신고한 유저의 ID는 `reporting_user_id`에 담음
    // (3) 신고 대상의 작성자 ID는 `user_id` 필드에 담기
    report.target_user_id = targetUserId;
    report.reporting_user_id = reporting_user_id; // 신고한 유저의 ID를 `reporting_user_id` 필드에 저장

    // 신고 유형이 0,1,4,6,7,8인 경우
    const immediateSuspendTypes = [0, 1, 4, 6, 7, 8];
    const user = await User.findByPk(targetUserId);
    
    if (user) {
        user.reported_count += 1;
        if (immediateSuspendTypes.includes(report_type) && user.status === "A") {
            user.status = "S";
        }
        else if (user.reported_count >= 3 && user.status === "A") {
            user.status = "S";
        }
        await user.save();
    }

    // 챌린지 참여 신고인 경우 (target_type === "L")
    if (target_type === "L") {
        const participation = await ChallengeParticipation.findByPk(target_id);
        if (participation) {
            participation.challenge_reported_count += 1;
            
            // 심각한 위반인 경우 즉시 "신고 대상" 상태로 변경
            if (immediateSuspendTypes.includes(report_type)) {
                participation.status = "신고 대상";
            }
            await participation.save();
        }
    }

    // 신고된 컨텐츠의 isShow 처리
    if (target_type === "P") {
        const post = await Post.findByPk(target_id);
        if (post) {
            await post.update({ isShow: false });
        }
    } else if (target_type === "C") {
        const comment = await Comment.findByPk(target_id);
        if (comment) {
            await comment.update({ isShow: false });
        }
    }
  });

  return Report;
};
