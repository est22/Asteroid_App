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
    }
  }
  User.init(
    {
      email: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      password: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      nickname: {
        type: DataTypes.STRING,
        allowNull: true,
        unique: true,
      },
      profile_picture: { type: DataTypes.STRING },
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
      device_token: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      apple_id: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      kakao_id: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      google_id: {
        type: DataTypes.STRING,
        allowNull: true
      },
      naver_id: {
        type: DataTypes.STRING,
        allowNull: true
      }
    },
    {
      sequelize,
      modelName: "User",
      timestamps: true,
    }
  );
User.addHook("afterUpdate", async (user, options) => {
  if (user.status === "S") {
    const updateTime = user.updatedAt;
    const threeDaysLater = new Date(updateTime.getTime() + 3 * 24 * 60 * 60 * 1000);

    if (new Date() >= threeDaysLater) {
      user.status = "A";
      await user.save();
      
      // Push Notification 발송
      await sendPushNotification({
        deviceToken: user.device_token, // User 모델에 device_token 필드 추가 필요
        title: "계정 상태 알림",
        body: "계정 정지가 해제되었습니다.",
        data: {
          type: "suspension_lifted",
          userId: user.id
        }
      });
    }
  }
});


  return User;
};
