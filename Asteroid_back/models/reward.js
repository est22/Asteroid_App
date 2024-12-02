const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Reward extends Model {
    static associate(models) {
      Reward.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });
      Reward.belongsTo(models.Challenge, {
        foreignKey: "challenge_id",
        onDelete: "CASCADE",
      });
      Reward.belongsTo(models.ChallengeParticipation, {
        foreignKey: "challenge_id",
        constraints: false,
      });
    }
  }

  Reward.init(
    {
      challenge_id: DataTypes.INTEGER,
      user_id: DataTypes.INTEGER,
      credit: {
        type: DataTypes.INTEGER,
        defaultValue: 0
      }
    },
    {
      sequelize,
      modelName: "Reward",
    }
  );

  return Reward;
};
