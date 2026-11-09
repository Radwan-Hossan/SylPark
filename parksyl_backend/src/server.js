const app = require('./app');
const { PORT, HOST } = require('./config/constants');
const { seedInitialData } = require('./utils/seed');

async function startServer() {
  try {
    // Seed initial demo data if files don't exist yet
    await seedInitialData();

    app.listen(PORT, HOST, () => {
      console.log('========================================================');
      console.log(`  SylPark Local Backend Server Running`);
      console.log(`  - Local URL:        http://localhost:${PORT}/api/health`);
      console.log(`  - Android Emulator: http://10.0.2.2:${PORT}/api/health`);
      console.log(`  - Host Binding:     ${HOST}:${PORT}`);
      console.log(`  - Data Directory:   JSON Files (No Database)`);
      console.log('========================================================');
    });
  } catch (err) {
    console.error('Failed to start SylPark server:', err);
    process.exit(1);
  }
}

startServer();
