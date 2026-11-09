const { readJson, writeJson } = require('../utils/fileStorage');

const VEHICLES_FILE = 'rental_vehicles.json';
const BOOKINGS_FILE = 'rental_bookings.json';

function generateRentalId() {
  return 'RENT-' + Math.random().toString(36).substring(2, 6).toUpperCase() + '-' + Date.now().toString().slice(-4);
}

// Get all rental vehicles
async function getVehicles(req, res) {
  try {
    const vehicles = await readJson(VEHICLES_FILE, []);
    return res.status(200).json({
      success: true,
      count: vehicles.length,
      data: vehicles,
    });
  } catch (err) {
    console.error('getRentalVehicles error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve rental vehicles.',
    });
  }
}

// Get rental vehicle by ID
async function getVehicleById(req, res) {
  try {
    const { id } = req.params;
    const vehicles = await readJson(VEHICLES_FILE, []);
    const vehicle = vehicles.find((v) => v.id === id);

    if (!vehicle) {
      return res.status(404).json({
        success: false,
        message: 'Rental vehicle not found.',
      });
    }

    return res.status(200).json({
      success: true,
      data: vehicle,
    });
  } catch (err) {
    console.error('getRentalVehicleById error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve vehicle details.',
    });
  }
}

// Submit car rental request
async function createRentalRequest(req, res) {
  try {
    const {
      vehicleId,
      startDate,
      endDate,
      durationDays,
      driverOption, // 'self-drive' or 'with-driver'
      additionalNotes,
    } = req.body;

    if (!vehicleId || !startDate || !endDate || !durationDays) {
      return res.status(400).json({
        success: false,
        message: 'Missing required rental fields (vehicleId, startDate, endDate, durationDays).',
      });
    }

    const vehicles = await readJson(VEHICLES_FILE, []);
    const vehicle = vehicles.find((v) => v.id === vehicleId);

    if (!vehicle) {
      return res.status(404).json({
        success: false,
        message: 'Selected rental vehicle not found.',
      });
    }

    const days = Math.max(1, Math.round(Number(durationDays)));
    const driverFeePerDay = driverOption === 'with-driver' ? 600 : 0;
    const totalDailyRate = vehicle.dailyPrice + driverFeePerDay;
    const estimatedTotalPrice = days * totalDailyRate;

    const newRentalBooking = {
      id: generateRentalId(),
      userId: req.user.id,
      userName: req.user.name,
      userPhone: req.user.phone || '',
      vehicleId: vehicle.id,
      vehicleName: vehicle.name,
      category: vehicle.category,
      vehicleImage: vehicle.image,
      capacity: vehicle.capacity,
      transmission: vehicle.transmission,
      fuelType: vehicle.fuelType,
      startDate: startDate.trim(),
      endDate: endDate.trim(),
      durationDays: days,
      dailyRate: vehicle.dailyPrice,
      driverOption: driverOption || 'self-drive',
      driverFeePerDay,
      totalPrice: estimatedTotalPrice,
      additionalNotes: additionalNotes ? additionalNotes.trim() : '',
      status: 'pending', // 'pending' | 'confirmed' | 'completed' | 'cancelled'
      createdAt: new Date().toISOString(),
      isDemo: true,
      demoNotice: 'Demonstration rental request for academic presentation. No real vehicle reserved.',
    };

    const bookings = await readJson(BOOKINGS_FILE, []);
    bookings.unshift(newRentalBooking);
    await writeJson(BOOKINGS_FILE, bookings);

    return res.status(201).json({
      success: true,
      message: 'Car rental reservation request submitted successfully!',
      data: newRentalBooking,
    });
  } catch (err) {
    console.error('createRentalRequest error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to submit rental request.',
    });
  }
}

// Get user rental requests
async function getUserRentalRequests(req, res) {
  try {
    const bookings = await readJson(BOOKINGS_FILE, []);
    const userBookings = bookings.filter((b) => b.userId === req.user.id);
    userBookings.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

    return res.status(200).json({
      success: true,
      count: userBookings.length,
      data: userBookings,
    });
  } catch (err) {
    console.error('getUserRentalRequests error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve rental requests.',
    });
  }
}

module.exports = {
  getVehicles,
  getVehicleById,
  createRentalRequest,
  getUserRentalRequests,
};
