const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class PostImage extends Model {
    static associate(models) {
      ChallengeImage.belongsTo(models.Post, {
        foreignKey: "post_id",
        onDelete: "CASCADE",
      });
    }
  }

  PostImage.init(
    {
      image_url: DataTypes.STRING,
      post_id: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "PostImage",
    }
  );

  return PostImage;
};
