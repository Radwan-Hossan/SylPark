const { readJson, writeJson } = require('../utils/fileStorage');

const USERS_FILE = 'users.json';

// Get current profile
async function getProfile(req, res) {
  try {
    const users = await readJson(USERS_FILE, []);
    const user = users.find((u) => u.id === req.user.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    const { passwordHash: _, ...userSafe } = user;
    return res.status(200).json({
      success: true,
      data: { user: userSafe },
    });
  } catch (err) {
    console.error('getProfile error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch user profile.',
    });
  }
}

// Update profile
async function updateProfile(req, res) {
  try {
    const { name, phone, avatar, vehicleInfo } = req.body;
    const users = await readJson(USERS_FILE, []);
    const index = users.findIndex((u) => u.id === req.user.id);

    if (index === -1) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    if (name) users[index].name = name.trim();
    if (phone) users[index].phone = phone.trim();
    if (avatar !== undefined) users[index].avatar = avatar;
    if (vehicleInfo !== undefined) users[index].vehicleInfo = vehicleInfo;
    users[index].updatedAt = new Date().toISOString();

    await writeJson(USERS_FILE, users);

    const { passwordHash: _, ...userSafe } = users[index];
    return res.status(200).json({
      success: true,
      message: 'Profile updated successfully.',
      data: { user: userSafe },
    });
  } catch (err) {
    console.error('updateProfile error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to update user profile.',
    });
  }
}

module.exports = {
  getProfile,
  updateProfile,
};
