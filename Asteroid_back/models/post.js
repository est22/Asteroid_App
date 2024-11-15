const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Post extends Model {
    static associate(models) {
      Post.hasMany(models.Like, { foreignKey: "post_id" });
      Post.hasMany(models.Comment, { foreignKey: "post_id" });
      Post.hasMany(models.PostImage, { foreignKey: "post_id" });

      Post.belongsTo(models.Category, {
        foreignKey: "category_id",
        onDelete: "CASCADE",
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
      created_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
      category_id: DataTypes.INTEGER,
      user_id: DataTypes.INTEGER,
      image: DataTypes.STRING,
    },
    {
      sequelize,
      modelName: "Post",
    }
  );

  return Post;
};
