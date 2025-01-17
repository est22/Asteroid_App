const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class ChallengeParticipation extends Model {
    static associate(models) {
      ChallengeParticipation.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });
      ChallengeParticipation.belongsTo(models.Challenge, {
        foreignKey: "challenge_id",
        onDelete: "CASCADE",
      });
      ChallengeParticipation.hasOne(models.Reward, {
        foreignKey: "challenge_id"
      });
    }
  }

  ChallengeParticipation.init(
    {
      user_id: DataTypes.INTEGER,
      challenge_id: DataTypes.INTEGER,
      status: {
        type: DataTypes.STRING,
        // 상태 타입: "참여중", "챌린지 달성", "챌린지 수료", "신고 대상"
        defaultValue: "참여중",
      },
      start_date: DataTypes.DATE,
      end_date: DataTypes.DATE,
      challenge_reported_count: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
      },
    },
    {
      sequelize,
      modelName: "ChallengeParticipation",
    }
  );

  return ChallengeParticipation;
};
