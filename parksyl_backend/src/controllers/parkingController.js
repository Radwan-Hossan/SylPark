const { readJson } = require('../utils/fileStorage');

const PARKING_FILE = 'parking.json';

// Get all parking with filters
async function getAll(req, res) {
  try {
    const {
      search,
      area,
      vehicleType,
      parkingType,
      maxPrice,
      facility,
      sort,
    } = req.query;

    let items = await readJson(PARKING_FILE, []);

    // Text search
    if (search && search.trim()) {
      const q = search.trim().toLowerCase();
      items = items.filter(
        (p) =>
          p.name.toLowerCase().includes(q) ||
          p.area.toLowerCase().includes(q) ||
          p.address.toLowerCase().includes(q)
      );
    }

    // Filter by area
    if (area && area.trim() && area.toLowerCase() !== 'all') {
      items = items.filter((p) => p.area.toLowerCase() === area.trim().toLowerCase());
    }

    // Filter by vehicle type
    if (vehicleType && vehicleType.trim() && vehicleType.toLowerCase() !== 'all') {
      items = items.filter((p) =>
        p.vehicleTypes.map((v) => v.toLowerCase()).includes(vehicleType.trim().toLowerCase())
      );
    }

    // Filter by parking type (Covered, Open, Multi-level, Underground)
    if (parkingType && parkingType.trim() && parkingType.toLowerCase() !== 'all') {
      items = items.filter((p) => p.parkingType.toLowerCase() === parkingType.trim().toLowerCase());
    }

    // Filter by max price
    if (maxPrice && !isNaN(Number(maxPrice))) {
      items = items.filter((p) => p.pricePerHour <= Number(maxPrice));
    }

    // Filter by facility
    if (facility && facility.trim()) {
      items = items.filter((p) =>
        p.facilities.some((f) => f.toLowerCase() === facility.trim().toLowerCase())
      );
    }

    // Sort
    if (sort) {
      if (sort === 'price_asc') {
        items.sort((a, b) => a.pricePerHour - b.pricePerHour);
      } else if (sort === 'price_desc') {
        items.sort((a, b) => b.pricePerHour - a.pricePerHour);
      } else if (sort === 'rating') {
        items.sort((a, b) => b.rating - a.rating);
      } else if (sort === 'name') {
        items.sort((a, b) => a.name.localeCompare(b.name));
      }
    }

    return res.status(200).json({
      success: true,
      count: items.length,
      data: items,
    });
  } catch (err) {
    console.error('getAll parking error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve parking locations.',
    });
  }
}

// Get single parking by ID
async function getById(req, res) {
  try {
    const { id } = req.params;
    const items = await readJson(PARKING_FILE, []);
    const parking = items.find((p) => p.id === id);

    if (!parking) {
      return res.status(404).json({
        success: false,
        message: `Parking location with ID "${id}" was not found.`,
      });
    }

    return res.status(200).json({
      success: true,
      data: parking,
    });
  } catch (err) {
    console.error('getById parking error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve parking details.',
    });
  }
}

// Search parking specifically
async function search(req, res) {
  try {
    const { q } = req.query;
    if (!q || !q.trim()) {
      const items = await readJson(PARKING_FILE, []);
      return res.status(200).json({ success: true, count: items.length, data: items });
    }

    const keyword = q.trim().toLowerCase();
    const items = await readJson(PARKING_FILE, []);
    const filtered = items.filter(
      (p) =>
        p.name.toLowerCase().includes(keyword) ||
        p.area.toLowerCase().includes(keyword) ||
        p.address.toLowerCase().includes(keyword)
    );

    return res.status(200).json({
      success: true,
      count: filtered.length,
      data: filtered,
    });
  } catch (err) {
    console.error('search parking error:', err);
    return res.status(500).json({
      success: false,
      message: 'Search query failed.',
    });
  }
}

module.exports = {
  getAll,
  getById,
  search,
};
