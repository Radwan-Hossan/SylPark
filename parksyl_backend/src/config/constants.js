const path = require('path');
require('dotenv').config();

module.exports = {
  PORT: process.env.PORT || 3000,
  HOST: process.env.HOST || '0.0.0.0',
  JWT_SECRET: process.env.JWT_SECRET || 'sylpark_super_secret_jwt_key_2026_sylhet',
  DATA_DIR: path.join(__dirname, '../../data'),
};
