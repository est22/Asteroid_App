require("dotenv").config();

module.exports = {
  development: {
    // 로컬 DB
    // username: process.env.DB_USER,
    // password: process.env.DB_PASS,
    // host: process.env.DB_HOST,
    // dialect: "postgresql",
    // database: process.env.DB_NAME,
    
    // Azure DB
    username: process.env.AZURE_USERNAME,
    password: process.env.AZURE_PASSWORD,
    host: process.env.AZURE_HOST,
    dialect: process.env.AZURE_DIALECT,
    database: process.env.AZURE_DATABASE,
    dialectOptions: {
      ssl: {
        require: true,
        rejectUnauthorized: false,
      },
    }, // Azure DB
  },
  test: {
    username: process.env.DB_USER,
    password: process.env.DB_PASS,
    host: process.env.DB_HOST,
    dialect: process.env.AZURE_DIALECT,
    database: process.env.DB_NAME,
  },
  production: {
    username: process.env.AZURE_USERNAME,
    password: process.env.AZURE_PASSWORD,
    host: process.env.AZURE_HOST,
    dialect: process.env.AZURE_DIALECT,
    database: process.env.AZURE_DATABASE,
    dialectOptions: {
      ssl: {
        require: true,
        rejectUnauthorized: false,
      },
    },
  },
};
