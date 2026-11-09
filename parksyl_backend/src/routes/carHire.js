const express = require('express');
const router = express.Router();
const carHireController = require('../controllers/carHireController');
const authenticateToken = require('../middleware/auth');

// Public listing
router.get('/', carHireController.getVehicles);
router.get('/:id', carHireController.getVehicleById);

// Protected booking endpoints
router.post('/bookings', authenticateToken, carHireController.createHireRequest);
router.get('/bookings/my', authenticateToken, carHireController.getUserHireRequests);

module.exports = router;
