const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class ChallengeImage extends Model {
    static associate(models) {
      ChallengeImage.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });
      ChallengeImage.belongsTo(models.Challenge, {
        foreignKey: "challenge_id",
        onDelete: "CASCADE",
      });
    }
  }

  ChallengeImage.init(
    {
      image_url: DataTypes.BLOB,
      user_id: DataTypes.INTEGER,
      challenge_id: DataTypes.INTEGER,
      upload_date: { // 챌린지 일일 참여 트래킹을 위한 추가
        type: DataTypes.DATEONLY,
        allowNull: false,
      }
    },
    {
      sequelize,
      modelName: "ChallengeImage",
    }
  );

  return ChallengeImage;
};
