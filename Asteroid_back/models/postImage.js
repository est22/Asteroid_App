const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class PostImage extends Model {
    static associate(models) {
      PostImage.belongsTo(models.Post, {
        foreignKey: "post_id",
        onDelete: "CASCADE",
      });
    }
  }

  PostImage.init(
    {
      image_url: DataTypes.BLOB,
      post_id: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "PostImage",
    }
  );

  return PostImage;
};
