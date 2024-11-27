const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    static associate(models) {
      User.hasMany(models.Report, { foreignKey: "reporting_user_id" }); // 신고를 만든 유저
      User.hasMany(models.Report, { foreignKey: "target_user_id" }); // 신고를 받은 유저
      User.hasMany(models.Post, { foreignKey: "user_id" });
      User.hasMany(models.Like, { foreignKey: "user_id" });
      User.hasMany(models.BalanceVote, { foreignKey: "user_id" });
      User.hasMany(models.Comment, { foreignKey: "user_id" });
      User.hasMany(models.ChallengeParticipation, { foreignKey: "user_id" });
      User.hasMany(models.Reward, { foreignKey: "user_id" });
      User.hasMany(models.Message, { foreignKey: "sender_user_id" });
      User.hasMany(models.Message, { foreignKey: "receiver_user_id" });
      User.hasMany(models.ChallengeImage, { foreignKey: "user_id" });
      User.hasMany(models.PostImage, { foreignKey: "user_id" });
    }
  }
  User.init(
    {
      email: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      password: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      nickname: {
        type: DataTypes.STRING,
        allowNull: true,
        unique: true,
      },
      profile_picture: { type: DataTypes.BLOB }, // BLOB 형식으로 변경
      motto: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      reported_count: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
      },
      status: {
        type: DataTypes.CHAR(1),
        allowNull: true,
        defaultValue: "A", // A: Active, S: Suspended, D:Deactivated
      },
    },
    {
      sequelize,
      modelName: "User",
      timestamps: true,
    }
  );
User.addHook("afterUpdate", async (user, options) => {
  if (user.status === "S") {
    const Post = sequelize.models.Post;
    const Comment = sequelize.models.Comment;
    const BalanceVote = sequelize.models.BalanceVote;

    // (1) 관련 Post의 isShow를 false로 변경
    await Post.update(
      { isShow: false },
      { where: { user_id: user.id } } // 해당 유저의 모든 게시글
    );

    // (2) 관련 Comment의 isShow를 false로 변경
    await Comment.update(
      { isShow: false },
      { where: { user_id: user.id } } // 해당 유저의 모든 댓글
    );

    // (3) 관련 BalanceVote의 isShow를 false로 변경
    await BalanceVote.update(
      { isShow: false },
      { where: { user_id: user.id } } // 해당 유저의 모든 Vote
    );

    console.log(
      `User ${user.id}의 상태 변경으로 해당 게시글과 댓글이 숨겨졌습니다.`
    );

    // (4) 정지 상태로 변경된 유저의 상태 변경 시간을 기록한 후,
    // 3일 후에 자동으로 'A'로 복구
    const updateTime = user.updatedAt;

    // 3일 후 계산
    const threeDaysLater = new Date(updateTime.getTime() + 3 * 24 * 60 * 60 * 1000); // 3일 후의 시간

    // 현재 시간이 3일 후가 지나면 상태를 'A'로 변경
    if (new Date() >= threeDaysLater) {
      user.status = "A";
      await user.save(); // 상태 변경을 DB에 반영
      console.log(`User ${user.id}의 상태가 자동으로 복구되었습니다.`);
    }
  }
});


  return User;
};
