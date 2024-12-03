const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class BalanceVote extends Model {
    static associate(models) {
      BalanceVote.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });
    }
  }

  BalanceVote.init(
    {
      title: DataTypes.STRING(23),
      description: DataTypes.STRING(100),
      user_id: DataTypes.INTEGER,
      image1: DataTypes.BLOB,
      image2: DataTypes.BLOB,
      vote1_count: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
      },
      vote2_count: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
      },
      isShow: DataTypes.BOOLEAN,
    },
    {
      sequelize,
      modelName: "BalanceVote",
    }
  );

  return BalanceVote;
};
