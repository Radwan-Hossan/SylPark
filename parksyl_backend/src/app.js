const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const parkingRoutes = require('./routes/parking');
const favoritesRoutes = require('./routes/favorites');
const bookingRoutes = require('./routes/bookings');
const carHireRoutes = require('./routes/carHire');
const carRentalRoutes = require('./routes/carRental');

const app = express();

// Security and CORS
app.use(cors({ origin: '*' }));
app.use(express.json());

// Request logger for easy demonstration debugging
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`[API] ${req.method} ${req.originalUrl} - ${res.statusCode} (${duration}ms)`);
  });
  next();
});

// Health check endpoint (mandatory for connectivity testing)
app.get('/api/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    app: 'SylPark Local REST API',
    version: '1.0.0',
    location: 'Sylhet City, Bangladesh',
    timestamp: new Date().toISOString(),
    demoAccount: {
      email: 'demo@parksyl.com',
      password: 'Password123!',
    },
  });
});

// Mount modular routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/parking', parkingRoutes);
app.use('/api/favorites', favoritesRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/car-hire', carHireRoutes);
app.use('/api/car-rental', carRentalRoutes);

// 404 Catch-all handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: `API Route not found: ${req.method} ${req.originalUrl}`,
  });
});

// Centralized Error handler
app.use((err, req, res, next) => {
  console.error('[API Error]:', err.stack || err.message);
  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Internal Server Error',
  });
});

module.exports = app;
