require("dotenv").config(); 

module.exports = {
  development: {
    username: process.env.DB_USER,
    password: process.env.DB_PASS, 
    host: process.env.DB_HOST, 
    dialect: "postgresql",
    database: process.env.DB_NAME, 
  },
  test: {
    username: process.env.DB_USER,
    password: process.env.DB_PASS,
    host: process.env.DB_HOST,
    dialect: "postgresql",
    database: process.env.DB_NAME,
  },
  production: {
    username: process.env.DB_USER,
    password: process.env.DB_PASS,
    host: process.env.DB_HOST,
    dialect: "postgresql",
    database: process.env.DB_NAME,
  },
};
