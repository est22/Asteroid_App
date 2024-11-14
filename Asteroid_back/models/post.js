const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Post extends Model {}
  Post.init(
    {
      post_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
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
