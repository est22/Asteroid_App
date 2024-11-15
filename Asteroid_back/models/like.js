const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Like extends Model {
    static associate(models) {
      Like.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });
      Like.belongsTo(models.Post, {
        foreignKey: "post_id",
        onDelete: "CASCADE",
      });
      Like.belongsTo(models.Comment, {
        foreignKey: "comment_id",
        onDelete: "CASCADE",
      });
    }
  }
  Like.init(
    {
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
