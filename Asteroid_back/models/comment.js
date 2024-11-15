const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Comment extends Model {
    static associate(models) {
      Comment.hasMany(models.Like, { foreignKey: "comment_id" });
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
      Comment: DataTypes.STRING,
      created_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
      user_id: DataTypes.INTEGER,
      post_id: DataTypes.INTEGER,
      parent_comment_id: DataTypes.INTEGER,
      likes: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "Comment",
    }
  );

  return Comment;
};
