const bcrypt = require("bcryptjs");
const userService = require("../services/userService");
const { generateAccessToken, generateRefreshToken } = require("../utils/token.js");
const jwt = require("jsonwebtoken");

const refresh = (req, res) => {
  const { token } = req.body;
  if (!token) return res.sendStatus(401);
  jwt.verify(token, "refresh_secret", (err, user) => {
    if (err) return res.sendStatus(403);

    const accessToken = generateAccessToken(user);
    res.json(accessToken);
  });
};

const login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await userService.findUserByEmail(email);
    if (!user) {
      return res.status(400).json({ message: "Invalid email or password" });
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid email or password" });
    }
    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);
    res.json({
      accessToken,
      refreshToken,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const register = async (req, res) => {
  const { email, name, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    const user = await userService.createUser({
      email: email,
      name: name,
      password: hashedPassword,
    });
    res.status(201).json({ data: user });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

module.exports = {
  register,
  login,
  refresh,
};
