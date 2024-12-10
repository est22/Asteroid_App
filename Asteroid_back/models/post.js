const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Post extends Model {
    static associate(models) {
      Post.hasMany(models.Comment, { foreignKey: "post_id" });
      Post.hasMany(models.PostImage, { foreignKey: "post_id" });
      Post.hasMany(models.Like, {
        foreignKey: "target_id",
        constraints: false,
        scope: {
          target_type: 'P'
        }
      });
      Post.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });
    }
  }
  Post.init(
    {
      title: DataTypes.STRING,
      content: DataTypes.STRING,
      category_id: DataTypes.INTEGER,
      user_id: DataTypes.INTEGER,
      isShow: { type: DataTypes.BOOLEAN, defaultValue: true },
      likeTotal: { type: DataTypes.INTEGER, defaultValue: 0 },
    },
    {
      sequelize,
      modelName: "Post",
    }
  );

  return Post;
};
