const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    static associate(models) {
      User.hasMany(models.Report, { foreignKey: "user_id" });
      User.hasMany(models.Post, { foreignKey: "user_id" });
      User.hasMany(models.Like, { foreignKey: "user_id" });
      User.hasMany(models.BalanceVote, { foreignKey: "user_id" });
      User.hasMany(models.Comment, { foreignKey: "user_id" });
      User.hasMany(models.ChallengeParticipation, { foreignKey: "user_id" });
      User.hasMany(models.Reward, { foreignKey: "user_id" });
      User.hasMany(models.Message, { foreignKey: "sender_user_id" });
      User.hasMany(models.Message, { foreignKey: "receiver_user_id" });
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
      nickname: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
      },
      profile_picture: { type: DataTypes.BLOB }, // BLOB 형식으로 변경
      motto: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      reported_count: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
      },
    },
    {
      sequelize,
      modelName: "User",
      timestamps: true,
    }
  );

  return User;
};
