const multer = require("multer");
const { storage } = require("../services/fileUploadService2");
const upload = multer({ storage: storage });

module.exports = upload;
