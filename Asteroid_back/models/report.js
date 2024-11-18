const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Report extends Model {
    static associate(models) {
      Report.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });
    }
  }
  Report.init(
    {
      user_id: DataTypes.INTEGER,
      target_type: DataTypes.CHAR(1),
      target_id: DataTypes.INTEGER,
      report_reason: DataTypes.STRING,
      report_type: DataTypes.SMALLINT,
    },
    {
      sequelize,
      modelName: "Report",
      indexes: [
        {
          unique: true,
          fields: ["target_type", "target_id", "report_type"],
        },
      ],
    }
  );

  return Report;
};
