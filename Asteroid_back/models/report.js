const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Report extends Model {
    static associate(models) {
      Post.hasMany(models.Like, { foreignKey: "comment_id" });

      Report.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });
    }
  }
  Report.init(
    {
      report_target_type: DataTypes.STRING,
      reported_target_id: DataTypes.INTEGER,
      user_id: DataTypes.INTEGER,
      created_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
      report_reason: DataTypes.STRING,
    },
    {
      sequelize,
      modelName: "Report",
    }
  );

  return Report;
};
