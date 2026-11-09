const express = require('express');
const router = express.Router();
const carRentalController = require('../controllers/carRentalController');
const authenticateToken = require('../middleware/auth');

// Public listing
router.get('/', carRentalController.getVehicles);
router.get('/:id', carRentalController.getVehicleById);

// Protected booking endpoints
router.post('/bookings', authenticateToken, carRentalController.createRentalRequest);
router.get('/bookings/my', authenticateToken, carRentalController.getUserRentalRequests);

module.exports = router;
