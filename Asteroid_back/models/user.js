const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    static associate(models) {
      User.hasMany(models.Post, { foreignKey: "user_id" });
      User.hasMany(models.BalanceVote, { foreignKey: "user_id" });
      User.hasMany(models.Comment, { foreignKey: "user_id" });
      User.hasMany(models.ChallengeMember, { foreignKey: "user_id" });
      User.hasMany(models.Reward, { foreignKey: "user_id" });
      User.hasMany(models.Message, { foreignKey: "sender_user_id" });
      User.hasMany(models.Message, { foreignKey: "receiver_user_id" });
      User.hasMany(models.Like, { foreignKey: "user_id" });
      User.hasMany(models.Report, { foreignKey: "user_id" });
      User.hasMany(models.ChallengeImage, { foreignKey: "user_id" });
    }
  }
  User.init(
    {
      email: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      password: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      nickname: DataTypes.STRING,
      profile_picture: DataTypes.STRING,
      motto: DataTypes.STRING,
      created_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
      reported_count: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
      },
    },
    {
      sequelize,
      modelName: "User",
    }
  );

  return User;
};
