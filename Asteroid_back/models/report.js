const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Report extends Model {}
  Report.init(
    {
      report_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
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
