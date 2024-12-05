require("dotenv").config();

module.exports = {
  development: {
    username: process.env.AZURE_USERNAME,
    password: process.env.AZURE_PASSWORD,
    host: process.env.AZURE_HOST,
    dialect: process.env.AZURE_DIALECT,
    database: process.env.AZURE_DATABASE,
  },
  production: {
    username: process.env.AZURE_USERNAME,
    password: process.env.AZURE_PASSWORD,
    host: process.env.AZURE_HOST,
    dialect: process.env.AZURE_DIALECT,
    database: process.env.AZURE_DATABASE,
  },
};
