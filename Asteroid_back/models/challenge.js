const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Challenge extends Model {}

  Challenge.init(
    {
      challenge_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
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
