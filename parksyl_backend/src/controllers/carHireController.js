const { readJson, writeJson } = require('../utils/fileStorage');

const VEHICLES_FILE = 'car_hire_vehicles.json';
const BOOKINGS_FILE = 'car_hire_bookings.json';

function generateHireId() {
  return 'HIRE-' + Math.random().toString(36).substring(2, 6).toUpperCase() + '-' + Date.now().toString().slice(-4);
}

// Get all hire vehicles
async function getVehicles(req, res) {
  try {
    const vehicles = await readJson(VEHICLES_FILE, []);
    return res.status(200).json({
      success: true,
      count: vehicles.length,
      data: vehicles,
    });
  } catch (err) {
    console.error('getVehicles error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve car hire vehicles.',
    });
  }
}

// Get hire vehicle by ID
async function getVehicleById(req, res) {
  try {
    const { id } = req.params;
    const vehicles = await readJson(VEHICLES_FILE, []);
    const vehicle = vehicles.find((v) => v.id === id);

    if (!vehicle) {
      return res.status(404).json({
        success: false,
        message: 'Car hire vehicle not found.',
      });
    }

    return res.status(200).json({
      success: true,
      data: vehicle,
    });
  } catch (err) {
    console.error('getVehicleById error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve vehicle details.',
    });
  }
}

// Submit car hire journey request
async function createHireRequest(req, res) {
  try {
    const {
      vehicleId,
      pickupLocation,
      destination,
      travelDate,
      pickupTime,
      passengerCount,
      additionalNotes,
    } = req.body;

    if (!vehicleId || !pickupLocation || !destination || !travelDate || !pickupTime || !passengerCount) {
      return res.status(400).json({
        success: false,
        message: 'Missing required hire fields (vehicleId, pickupLocation, destination, travelDate, pickupTime, passengerCount).',
      });
    }

    const vehicles = await readJson(VEHICLES_FILE, []);
    const vehicle = vehicles.find((v) => v.id === vehicleId);

    if (!vehicle) {
      return res.status(404).json({
        success: false,
        message: 'Selected vehicle not found.',
      });
    }

    const newHireBooking = {
      id: generateHireId(),
      userId: req.user.id,
      userName: req.user.name,
      userPhone: req.user.phone || '',
      vehicleId: vehicle.id,
      vehicleName: vehicle.name,
      vehicleType: vehicle.type,
      vehicleImage: vehicle.image,
      capacity: vehicle.capacity,
      pickupLocation: pickupLocation.trim(),
      destination: destination.trim(),
      travelDate: travelDate.trim(),
      pickupTime: pickupTime.trim(),
      passengerCount: Number(passengerCount),
      estimatedFare: vehicle.baseFare || 2500,
      additionalNotes: additionalNotes ? additionalNotes.trim() : '',
      status: 'pending', // 'pending' | 'confirmed' | 'completed' | 'cancelled'
      createdAt: new Date().toISOString(),
      isDemo: true,
      driverAssigned: 'Demo Driver (Driver details will be shared on confirmation)',
      demoNotice: 'Demonstration journey request. No real driver dispatched.',
    };

    const bookings = await readJson(BOOKINGS_FILE, []);
    bookings.unshift(newHireBooking);
    await writeJson(BOOKINGS_FILE, bookings);

    return res.status(201).json({
      success: true,
      message: 'Car hire journey request submitted successfully!',
      data: newHireBooking,
    });
  } catch (err) {
    console.error('createHireRequest error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to submit car hire request.',
    });
  }
}

// Get user hire requests
async function getUserHireRequests(req, res) {
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
    console.error('getUserHireRequests error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve car hire requests.',
    });
  }
}

module.exports = {
  getVehicles,
  getVehicleById,
  createHireRequest,
  getUserHireRequests,
};
