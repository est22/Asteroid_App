const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Challenge extends Model {
    static associate(models) {
      Challenge.hasMany(models.ChallengeParticipation, {
        foreignKey: "challenge_id",
      });
      Challenge.hasMany(models.Reward, { foreignKey: "challenge_id" });
      Challenge.hasMany(models.ChallengeImage, { foreignKey: "challenge_id" });
    }
  }

  Challenge.init(
    {
      period: DataTypes.INTEGER,
      period: DataTypes.INTEGER,
      name: DataTypes.STRING,
      description: DataTypes.STRING,
      reward_name: DataTypes.STRING,
      reward_image_url: DataTypes.STRING,
      status: DataTypes.CHAR(1),
    },
    {
      sequelize,
      modelName: "Challenge",
    }
  );

  return Challenge;
};
