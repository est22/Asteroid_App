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
      name: DataTypes.STRING,
      description: DataTypes.STRING,
      reward_name: DataTypes.STRING,
      reward_image_url: DataTypes.STRING,
      created_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
    },
    {
      sequelize,
      modelName: "Challenge",
    }
  );

  return Challenge;
};
