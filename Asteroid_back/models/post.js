const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Post extends Model {
    static associate(models) {
      Post.hasMany(models.Comment, { foreignKey: "id" });
      Post.hasMany(models.PostImage, { foreignKey: "id" });

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
      category_id: DataTypes.INTEGER,
      user_id: DataTypes.INTEGER,
      isShow: DataTypes.BOOLEAN,
    },
    {
      sequelize,
      modelName: "Post",
    }
  );

  return Post;
};
