const { readJson, writeJson } = require('../utils/fileStorage');

const BOOKINGS_FILE = 'bookings.json';
const PARKING_FILE = 'parking.json';

function generateBookingId() {
  return 'BK-' + Math.random().toString(36).substring(2, 6).toUpperCase() + '-' + Date.now().toString().slice(-4);
}

// Create new parking booking
async function createBooking(req, res) {
  try {
    const {
      parkingId,
      vehicleType,
      vehiclePlate,
      bookingDate,
      startTime,
      endTime,
      durationHours,
      notes,
    } = req.body;

    if (!parkingId || !vehicleType || !bookingDate || !startTime || !endTime || !durationHours) {
      return res.status(400).json({
        success: false,
        message: 'Missing required booking fields (parkingId, vehicleType, bookingDate, startTime, endTime, durationHours).',
      });
    }

    const parkingList = await readJson(PARKING_FILE, []);
    const parking = parkingList.find((p) => p.id === parkingId);

    if (!parking) {
      return res.status(404).json({
        success: false,
        message: 'Selected parking location was not found.',
      });
    }

    const hours = Math.max(1, Math.round(Number(durationHours)));
    const calculatedPrice = hours * parking.pricePerHour;

    const newBooking = {
      id: generateBookingId(),
      userId: req.user.id,
      userName: req.user.name,
      userEmail: req.user.email,
      parkingId: parking.id,
      parkingName: parking.name,
      parkingArea: parking.area,
      parkingAddress: parking.address,
      parkingImage: parking.image,
      parkingCoordinates: parking.coordinates,
      pricePerHour: parking.pricePerHour,
      vehicleType: vehicleType.trim(),
      vehiclePlate: (vehiclePlate || 'N/A').trim(),
      bookingDate: bookingDate.trim(),
      startTime: startTime.trim(),
      endTime: endTime.trim(),
      durationHours: hours,
      totalPrice: calculatedPrice,
      notes: notes ? notes.trim() : '',
      status: 'ongoing', // 'ongoing' | 'completed' | 'cancelled'
      createdAt: new Date().toISOString(),
      isDemo: true,
      demoNotice: 'Demonstration booking for academic evaluation. Not a live reservation.',
    };

    const bookings = await readJson(BOOKINGS_FILE, []);
    bookings.unshift(newBooking);
    await writeJson(BOOKINGS_FILE, bookings);

    return res.status(201).json({
      success: true,
      message: 'Parking booking request confirmed successfully!',
      data: newBooking,
    });
  } catch (err) {
    console.error('createBooking error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to create parking booking.',
    });
  }
}

// Get user bookings
async function getUserBookings(req, res) {
  try {
    const { status } = req.query;
    const bookings = await readJson(BOOKINGS_FILE, []);

    // Filter by user ID
    let userBookings = bookings.filter((b) => b.userId === req.user.id);

    // Optional status filter
    if (status && status.trim() && status.toLowerCase() !== 'all') {
      userBookings = userBookings.filter(
        (b) => b.status.toLowerCase() === status.trim().toLowerCase()
      );
    }

    // Sort newest first
    userBookings.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

    return res.status(200).json({
      success: true,
      count: userBookings.length,
      data: userBookings,
    });
  } catch (err) {
    console.error('getUserBookings error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve bookings.',
    });
  }
}

// Get booking by ID
async function getBookingById(req, res) {
  try {
    const { id } = req.params;
    const bookings = await readJson(BOOKINGS_FILE, []);
    const booking = bookings.find((b) => b.id === id);

    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Booking not found.',
      });
    }

    // Ensure user only sees their own booking
    if (booking.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Unauthorized access to this booking.',
      });
    }

    return res.status(200).json({
      success: true,
      data: booking,
    });
  } catch (err) {
    console.error('getBookingById error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve booking details.',
    });
  }
}

// Cancel booking
async function cancelBooking(req, res) {
  try {
    const { id } = req.params;
    const bookings = await readJson(BOOKINGS_FILE, []);
    const index = bookings.findIndex((b) => b.id === id);

    if (index === -1) {
      return res.status(404).json({
        success: false,
        message: 'Booking not found.',
      });
    }

    if (bookings[index].userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Unauthorized to cancel this booking.',
      });
    }

    if (bookings[index].status === 'cancelled') {
      return res.status(400).json({
        success: false,
        message: 'This booking has already been cancelled.',
      });
    }

    bookings[index].status = 'cancelled';
    bookings[index].cancelledAt = new Date().toISOString();

    await writeJson(BOOKINGS_FILE, bookings);

    return res.status(200).json({
      success: true,
      message: 'Booking cancelled successfully.',
      data: bookings[index],
    });
  } catch (err) {
    console.error('cancelBooking error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to cancel booking.',
    });
  }
}

module.exports = {
  createBooking,
  getUserBookings,
  getBookingById,
  cancelBooking,
};
