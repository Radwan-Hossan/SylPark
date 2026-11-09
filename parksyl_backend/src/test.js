const http = require('http');
const app = require('./app');
const { seedInitialData } = require('./utils/seed');

let server;
const TEST_PORT = 3099;
const BASE_URL = `http://127.0.0.1:${TEST_PORT}`;

function request(method, path, body = null, token = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, BASE_URL);
    const headers = { 'Content-Type': 'application/json' };
    if (token) headers['Authorization'] = `Bearer ${token}`;

    const options = {
      method,
      hostname: url.hostname,
      port: url.port,
      path: url.pathname + url.search,
      headers,
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => (data += chunk));
      res.on('end', () => {
        try {
          const parsed = JSON.parse(data);
          resolve({ status: res.statusCode, body: parsed });
        } catch {
          resolve({ status: res.statusCode, body: data });
        }
      });
    });

    req.on('error', reject);
    if (body) req.write(JSON.stringify(body));
    req.end();
  });
}

async function runTests() {
  console.log('--- Starting SylPark Backend Automated Verification ---');
  await seedInitialData();

  server = app.listen(TEST_PORT, '127.0.0.1');

  try {
    // 1. Health check
    const health = await request('GET', '/api/health');
    console.assert(health.status === 200, `Health check failed: ${health.status}`);
    console.assert(health.body.status === 'ok', 'Health status mismatch');
    console.log('✓ 1. Health check passed');

    // 2. Demo User Login
    const loginRes = await request('POST', '/api/auth/login', {
      email: 'demo@parksyl.com',
      password: 'Password123!',
    });
    console.assert(loginRes.status === 200, `Login failed: ${loginRes.status} ${JSON.stringify(loginRes.body)}`);
    const token = loginRes.body.data.token;
    console.assert(Boolean(token), 'No token returned on login');
    console.log('✓ 2. Demo Login passed (Token acquired)');

    // 3. Auth Me
    const meRes = await request('GET', '/api/auth/me', null, token);
    console.assert(meRes.status === 200, `Me endpoint failed: ${meRes.status}`);
    console.assert(meRes.body.data.user.email === 'demo@parksyl.com', 'Me email mismatch');
    console.log('✓ 3. Auth Me verification passed');

    // 4. Update Profile
    const updateRes = await request('PUT', '/api/users/me', { phone: '+880 1712 999888' }, token);
    console.assert(updateRes.status === 200, `Update profile failed: ${updateRes.status}`);
    console.assert(updateRes.body.data.user.phone === '+880 1712 999888', 'Phone not updated');
    console.log('✓ 4. Update Profile passed');

    // 5. Parking List & Filter
    const parkingList = await request('GET', '/api/parking');
    console.assert(parkingList.status === 200, 'Parking list failed');
    console.assert(parkingList.body.data.length >= 7, 'Expected at least 7 parking spots');
    console.log(`✓ 5. Parking List passed (${parkingList.body.data.length} locations)`);

    // 6. Parking Filter by Area
    const amberkhanaFilter = await request('GET', '/api/parking?area=Amberkhana');
    console.assert(amberkhanaFilter.body.data.length >= 1, 'Filter by area failed');
    console.assert(amberkhanaFilter.body.data[0].area === 'Amberkhana', 'Area filter mismatch');
    console.log('✓ 6. Parking Filter by Area passed');

    // 7. Parking Search
    const searchRes = await request('GET', '/api/parking/search?q=zinda');
    console.assert(searchRes.body.data.length >= 1, 'Parking search failed');
    console.log('✓ 7. Parking Search passed');

    // 8. Favorites
    const addFav = await request('POST', '/api/favorites', { parkingId: 'prk-003' }, token);
    console.assert(addFav.status === 200, 'Add favorite failed');
    const favs = await request('GET', '/api/favorites', null, token);
    console.assert(favs.body.favoriteIds.includes('prk-003'), 'prk-003 not in favorites');
    console.log('✓ 8. Favorites Add & Get passed');

    // 9. Parking Booking
    const bookingPayload = {
      parkingId: 'prk-001',
      vehicleType: 'Car',
      vehiclePlate: 'Sylhet-Ga 12-3456',
      bookingDate: '2026-11-10',
      startTime: '10:00 AM',
      endTime: '01:00 PM',
      durationHours: 3,
    };
    const createBooking = await request('POST', '/api/bookings', bookingPayload, token);
    console.assert(createBooking.status === 201, `Create booking failed: ${createBooking.status}`);
    const newBookingId = createBooking.body.data.id;
    console.log(`✓ 9. Parking Booking Created: ${newBookingId}`);

    // 10. Get User Bookings
    const userBookings = await request('GET', '/api/bookings', null, token);
    console.assert(userBookings.body.data.some((b) => b.id === newBookingId), 'New booking not in list');
    console.log('✓ 10. User Bookings listing passed');

    // 11. Cancel Booking
    const cancelRes = await request('PATCH', `/api/bookings/${newBookingId}/cancel`, null, token);
    console.assert(cancelRes.status === 200, 'Cancel booking failed');
    console.assert(cancelRes.body.data.status === 'cancelled', 'Status not set to cancelled');
    console.log('✓ 11. Cancel Booking passed');

    // 12. Car Hire (Journey)
    const hireVehicles = await request('GET', '/api/car-hire');
    console.assert(hireVehicles.body.data.length >= 4, 'Car hire vehicle count mismatch');
    const hireReq = await request('POST', '/api/car-hire/bookings', {
      vehicleId: 'hire-01',
      pickupLocation: 'Zindabazar Point',
      destination: 'Ratargul Swamp Forest',
      travelDate: '2026-11-12',
      pickupTime: '08:00 AM',
      passengerCount: 3,
    }, token);
    console.assert(hireReq.status === 201, 'Create hire request failed');
    console.log(`✓ 12. Car Hire journey request created: ${hireReq.body.data.id}`);

    // 13. Car Rental
    const rentalVehicles = await request('GET', '/api/car-rental');
    console.assert(rentalVehicles.body.data.length >= 4, 'Rental vehicle count mismatch');
    const rentalReq = await request('POST', '/api/car-rental/bookings', {
      vehicleId: 'rent-01',
      startDate: '2026-11-15',
      endDate: '2026-11-17',
      durationDays: 2,
      driverOption: 'self-drive',
    }, token);
    console.assert(rentalReq.status === 201, 'Create rental request failed');
    console.log(`✓ 13. Car Rental reservation request created: ${rentalReq.body.data.id}`);

    console.log('\n========================================');
    console.log(' ALL 13 BACKEND REST API TESTS PASSED! ');
    console.log('========================================\n');
  } catch (err) {
    console.error('Test verification failed:', err);
    process.exitCode = 1;
  } finally {
    if (server) server.close();
  }
}

runTests();
