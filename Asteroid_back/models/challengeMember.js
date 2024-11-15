const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class ChallengeMember extends Model {
    static associate(models) {
      ChallengeMember.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });
      ChallengeMember.belongsTo(models.Challenge, {
        foreignKey: "challenge_id",
        onDelete: "CASCADE",
      });
    }
  }

  ChallengeMember.init(
    {
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
      modelName: "ChallengeMember",
    }
  );

  return ChallengeMember;
};
