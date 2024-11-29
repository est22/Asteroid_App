const multer = require("multer");
const { storage } = require("../services/fileUploadService");
const upload = multer({ storage: storage });

module.exports = upload;
