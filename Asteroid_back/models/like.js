const { Model, STRING } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Like extends Model {
    static associate(models) {
      Like.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });
    }
  }
  Like.init(
    {
      user_id: DataTypes.INTEGER,
      target_type: DataTypes.CHAR(1),
      target_id: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "Like",
      indexes: [
        {
          unique: true,
          fields: [ "user_id", "target_type", "target_id"],
        },
      ],
    }
  );

  return Like;
};
