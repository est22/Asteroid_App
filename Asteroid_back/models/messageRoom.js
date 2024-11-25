const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class MessageRoom extends Model {
    static associate(models) {
      MessageRoom.belongsTo(models.User, {
        as: "User1",
        foreignKey: "user1_id",
        onDelete: "CASCADE",
      });
      MessageRoom.belongsTo(models.User, {
        as: "User2",
        foreignKey: "user2_id",
        onDelete: "CASCADE",
      });
    }
  }

  MessageRoom.init(
    {
      user1_id: DataTypes.INTEGER,
      user2_id: DataTypes.INTEGER,
      user1_left_at: {
        type: DataTypes.DATE,
        allowNull: true,
      },
      user2_left_at: {
        type: DataTypes.DATE,
        allowNull: true,
      },
    },
    {
      sequelize,
      modelName: "MessageRoom",
    }
  );

  return MessageRoom;
};
