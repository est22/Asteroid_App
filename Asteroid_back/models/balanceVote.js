const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class VSBalanceVote extends Model {}

  VSBalanceVote.init(
    {
      vote_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      title: DataTypes.STRING,
      description: DataTypes.STRING,
      created_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
      user_id: DataTypes.INTEGER,
      image1: DataTypes.STRING,
      image2: DataTypes.STRING,
      vote1_count: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
      },
      vote2_count: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
      },
    },
    {
      sequelize,
      modelName: "VSBalanceVote",
    }
  );

  return VSBalanceVote;
};
