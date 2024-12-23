const jwt = require("jsonwebtoken");

const authenticateToken = (req, res, next) => {
  let token;
  if (req.headers.authorization) {
    token = req.headers.authorization.split(" ")[1];
  }
  if (!token) {
    return res.sendStatus(401);
  }
  jwt.verify(token, "access_secret", (err, user) => {
    if (err) return res.sendStatus(401);
    req.user = user;
    next();
  });
};

module.exports = {
  authenticateToken,
};
