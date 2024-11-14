const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class ChallengeParticipation extends Model {}

  ChallengeParticipation.init(
    {
      participation_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      user_id: DataTypes.INTEGER,
      challenge_id: DataTypes.INTEGER,
      status: DataTypes.STRING,
      start_date: DataTypes.DATE,
      end_date: DataTypes.DATE,
      completed: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
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
