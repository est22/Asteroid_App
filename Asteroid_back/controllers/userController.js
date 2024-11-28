const updateDeviceToken = async (req, res) => {
  try {
    const userId = req.user.id; // JWT 미들웨어에서 가져온 사용자 ID
    const { device_token } = req.body;

    await User.update(
      { device_token },
      { where: { id: userId } }
    );

    res.json({ success: true, message: "토큰이 업데이트되었습니다." });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}; 

module.exports = {
  updateDeviceToken
};
