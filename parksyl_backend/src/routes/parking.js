const express = require('express');
const router = express.Router();
const parkingController = require('../controllers/parkingController');

// Search endpoint before param route
router.get('/search', parkingController.search);
router.get('/', parkingController.getAll);
router.get('/:id', parkingController.getById);

module.exports = router;
