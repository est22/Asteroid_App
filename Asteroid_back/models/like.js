const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Like extends Model {}
  Like.init(
    {
      like_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      user_id: DataTypes.INTEGER,
      post_id: DataTypes.INTEGER,
      comment_id: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "Like",
    }
  );

  return Like;
};
