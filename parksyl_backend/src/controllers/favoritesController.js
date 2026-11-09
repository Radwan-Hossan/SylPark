const { readJson, writeJson } = require('../utils/fileStorage');

const FAVORITES_FILE = 'favorites.json';
const PARKING_FILE = 'parking.json';

// Get favorites for current user
async function getFavorites(req, res) {
  try {
    const favoritesData = await readJson(FAVORITES_FILE, []);
    const userFavs = favoritesData.find((f) => f.userId === req.user.id) || { parkingIds: [] };

    const parkingList = await readJson(PARKING_FILE, []);
    const favParkings = parkingList.filter((p) => userFavs.parkingIds.includes(p.id));

    return res.status(200).json({
      success: true,
      count: favParkings.length,
      favoriteIds: userFavs.parkingIds,
      data: favParkings,
    });
  } catch (err) {
    console.error('getFavorites error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve favorites.',
    });
  }
}

// Add favorite
async function addFavorite(req, res) {
  try {
    const { parkingId } = req.body;
    if (!parkingId) {
      return res.status(400).json({
        success: false,
        message: 'parkingId is required.',
      });
    }

    const parkingList = await readJson(PARKING_FILE, []);
    const exists = parkingList.some((p) => p.id === parkingId);
    if (!exists) {
      return res.status(404).json({
        success: false,
        message: 'Parking area not found.',
      });
    }

    const favoritesData = await readJson(FAVORITES_FILE, []);
    let userFavs = favoritesData.find((f) => f.userId === req.user.id);

    if (!userFavs) {
      userFavs = { userId: req.user.id, parkingIds: [] };
      favoritesData.push(userFavs);
    }

    if (!userFavs.parkingIds.includes(parkingId)) {
      userFavs.parkingIds.push(parkingId);
      await writeJson(FAVORITES_FILE, favoritesData);
    }

    return res.status(200).json({
      success: true,
      message: 'Added to favorites.',
      favoriteIds: userFavs.parkingIds,
    });
  } catch (err) {
    console.error('addFavorite error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to add to favorites.',
    });
  }
}

// Remove favorite
async function removeFavorite(req, res) {
  try {
    const { id: parkingId } = req.params;
    const favoritesData = await readJson(FAVORITES_FILE, []);
    const userFavs = favoritesData.find((f) => f.userId === req.user.id);

    if (userFavs) {
      userFavs.parkingIds = userFavs.parkingIds.filter((id) => id !== parkingId);
      await writeJson(FAVORITES_FILE, favoritesData);
    }

    return res.status(200).json({
      success: true,
      message: 'Removed from favorites.',
      favoriteIds: userFavs ? userFavs.parkingIds : [],
    });
  } catch (err) {
    console.error('removeFavorite error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to remove favorite.',
    });
  }
}

module.exports = {
  getFavorites,
  addFavorite,
  removeFavorite,
};
