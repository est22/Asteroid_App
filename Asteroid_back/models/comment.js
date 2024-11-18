const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Comment extends Model {
    static associate(models) {
      Comment.hasMany(models.Comment, { foreignKey: "parent_comment_id" });

      Comment.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });
      Comment.belongsTo(models.Post, {
        foreignKey: "post_id",
        onDelete: "CASCADE",
      });
      Comment.belongsTo(models.Comment, {
        foreignKey: "parent_comment_id",
        onDelete: "CASCADE",
      });
    }
  }

  Comment.init(
    {
      content: DataTypes.STRING,
      user_id: DataTypes.INTEGER,
      post_id: DataTypes.INTEGER,
      parent_comment_id: DataTypes.INTEGER,
      isShow: DataTypes.BOOLEAN,
    },
    {
      sequelize,
      modelName: "Comment",
    }
  );

  return Comment;
};
