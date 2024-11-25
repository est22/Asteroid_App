const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Message extends Model {
    static associate(models) {
      Message.belongsTo(models.User, {
        as: "Sender",
        foreignKey: "sender_user_id",
        onDelete: "CASCADE",
      });
      Message.belongsTo(models.User, {
        as: "Receiver",
        foreignKey: "receiver_user_id",
        onDelete: "CASCADE",
      });
    }
  }

  Message.init(
    {
      content: DataTypes.STRING,
      sender_user_id: DataTypes.INTEGER,
      receiver_user_id: DataTypes.INTEGER,
      is_read: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
    },
    {
      sequelize,
      modelName: "Message",
    }
  );
  return Message;
};
