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
      image_url: DataTypes.STRING,
      user_id: DataTypes.INTEGER,
      challenge_id: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "ChallengeImage",
    }
  );

  return ChallengeImage;
};
