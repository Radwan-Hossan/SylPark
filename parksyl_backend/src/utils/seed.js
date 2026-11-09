const bcrypt = require('bcryptjs');
const { readJson, writeJson } = require('./fileStorage');

async function seedInitialData() {
  // 1. Seed Demo User
  const users = await readJson('users.json', []);
  let demoUser = users.find((u) => u.email === 'demo@parksyl.com');

  if (!demoUser) {
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash('Password123!', salt);
    demoUser = {
      id: 'usr_demo_1001',
      name: 'Jhon Martin',
      email: 'demo@parksyl.com',
      phone: '+880 1712 345678',
      passwordHash,
      avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
      createdAt: new Date().toISOString(),
    };
    users.push(demoUser);
    await writeJson('users.json', users);
    console.log('[Seed] Demo user created: demo@parksyl.com / Password123!');
  }

  // 2. Seed Parking Data
  const parking = await readJson('parking.json', []);
  if (parking.length === 0) {
    const initialParking = [
      {
        id: 'prk-001',
        name: 'Premier City Center Parking',
        area: 'Zindabazar',
        address: '202 Zindabazar Point, Sylhet City, Bangladesh',
        coordinates: { lat: 24.8978, lng: 91.8715 },
        pricePerHour: 40,
        rating: 4.8,
        reviewCount: 142,
        totalSpots: 50,
        availableSpots: 18,
        statusLevel: 'Moderate',
        parkingType: 'Covered',
        vehicleTypes: ['Car', 'SUV', 'Bike'],
        facilities: ['CCTV Surveillance', '24/7 Security Guard', 'EV Charging Station', 'Fire Safety', 'Valet Assist'],
        openingHours: '24/7 Available',
        contactPhone: '+880 1711 002233',
        image: 'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?auto=format&fit=crop&w=800&q=80',
        description: 'Prime central parking facility located at Zindabazar. Features multi-level covered bays, round-the-clock CCTV, and swift automated gate access.',
        isDemo: true,
      },
      {
        id: 'prk-002',
        name: 'MetroPark Master Point',
        area: 'Amberkhana',
        address: 'Amberkhana Main Roundabout, Sylhet, Bangladesh',
        coordinates: { lat: 24.9036, lng: 91.8672 },
        pricePerHour: 35,
        rating: 4.7,
        reviewCount: 98,
        totalSpots: 40,
        availableSpots: 12,
        statusLevel: 'Available',
        parkingType: 'Multi-level',
        vehicleTypes: ['Car', 'SUV', 'Microbus'],
        facilities: ['CCTV Surveillance', 'Security Guard', 'Car Wash Facility', 'Wheelchair Access'],
        openingHours: '06:00 AM - 11:30 PM',
        contactPhone: '+880 1712 113344',
        image: 'https://images.unsplash.com/photo-1590674899484-d5640e854abe?auto=format&fit=crop&w=800&q=80',
        description: 'Spacious multi-level hub in the heart of Amberkhana with easy exit ramps to Airport Road and Subidbazar.',
        isDemo: true,
      },
      {
        id: 'prk-003',
        name: 'DriveGuard Solutions Hub',
        area: 'Subidbazar',
        address: 'Subidbazar High School Road, Sylhet, Bangladesh',
        coordinates: { lat: 24.9012, lng: 91.8540 },
        pricePerHour: 30,
        rating: 4.5,
        reviewCount: 76,
        totalSpots: 35,
        availableSpots: 8,
        statusLevel: 'Almost Full',
        parkingType: 'Covered',
        vehicleTypes: ['Car', 'SUV', 'Bike'],
        facilities: ['CCTV Surveillance', 'Security Guard', 'Covered Roof', 'Fire Extinguisher'],
        openingHours: '07:00 AM - 11:00 PM',
        contactPhone: '+880 1713 224455',
        image: 'https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?auto=format&fit=crop&w=800&q=80',
        description: 'Secure covered parking facility in Subidbazar offering shade protection, active security staff, and reserved bays.',
        isDemo: true,
      },
      {
        id: 'prk-004',
        name: 'Kumarpara SafePark Bay',
        area: 'Kumarpara',
        address: 'Kumarpara Point, Sylhet, Bangladesh',
        coordinates: { lat: 24.8932, lng: 91.8790 },
        pricePerHour: 25,
        rating: 4.4,
        reviewCount: 64,
        totalSpots: 25,
        availableSpots: 14,
        statusLevel: 'Available',
        parkingType: 'Open',
        vehicleTypes: ['Car', 'Bike'],
        facilities: ['Security Guard', 'Well Lit Area', '24/7 Access'],
        openingHours: '24/7 Available',
        contactPhone: '+880 1714 335566',
        image: 'https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=800&q=80',
        description: 'Affordable open parking space located near Kumarpara junction with quick access to Naiorpul and Shibgonj.',
        isDemo: true,
      },
      {
        id: 'prk-005',
        name: 'Mirabazar Commercial Park',
        area: 'Mirabazar',
        address: 'Mirabazar Commercial Tower, Sylhet, Bangladesh',
        coordinates: { lat: 24.8901, lng: 91.8845 },
        pricePerHour: 45,
        rating: 4.6,
        reviewCount: 110,
        totalSpots: 45,
        availableSpots: 21,
        statusLevel: 'Available',
        parkingType: 'Underground',
        vehicleTypes: ['Car', 'SUV', 'Microbus'],
        facilities: ['CCTV Surveillance', 'EV Charging Station', 'Security Guard', 'Elevator Access', 'Disabled Access'],
        openingHours: '08:00 AM - 10:00 PM',
        contactPhone: '+880 1715 446677',
        image: 'https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&w=800&q=80',
        description: 'Climate-controlled basement underground parking under Mirabazar shopping complex, complete with EV chargers.',
        isDemo: true,
      },
      {
        id: 'prk-006',
        name: 'Shibgonj Plaza Smart Parking',
        area: 'Shibgonj',
        address: 'Shibgonj Bazar Main Road, Sylhet, Bangladesh',
        coordinates: { lat: 24.8915, lng: 91.8960 },
        pricePerHour: 30,
        rating: 4.3,
        reviewCount: 52,
        totalSpots: 30,
        availableSpots: 9,
        statusLevel: 'Moderate',
        parkingType: 'Covered',
        vehicleTypes: ['Car', 'Bike'],
        facilities: ['CCTV Surveillance', 'Security Guard', 'Car Wash Facility'],
        openingHours: '07:00 AM - 11:00 PM',
        contactPhone: '+880 1716 557788',
        image: 'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?auto=format&fit=crop&w=800&q=80',
        description: 'Convenient shopping parking in Shibgonj plaza with fast turnarounds and vehicle wash services.',
        isDemo: true,
      },
      {
        id: 'prk-007',
        name: 'Shahjalal Uposhohor Eco Park',
        area: 'Shahjalal Uposhohor',
        address: 'Main Block D, Shahjalal Uposhohor, Sylhet, Bangladesh',
        coordinates: { lat: 24.8820, lng: 91.8785 },
        pricePerHour: 20,
        rating: 4.5,
        reviewCount: 88,
        totalSpots: 60,
        availableSpots: 35,
        statusLevel: 'Available',
        parkingType: 'Open',
        vehicleTypes: ['Car', 'SUV', 'Bike', 'Microbus'],
        facilities: ['CCTV Surveillance', 'Security Guard', 'Wide Entry Gate', '24/7 Access'],
        openingHours: '24/7 Available',
        contactPhone: '+880 1717 668899',
        image: 'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=800&q=80',
        description: 'Large open-air parking ground in Uposhohor, ideal for extended parking, family vans, and visitors.',
        isDemo: true,
      },
    ];
    await writeJson('parking.json', initialParking);
    console.log('[Seed] 7 Sylhet parking areas seeded.');
  }

  // 3. Seed Car Hire Vehicles (Journey with Driver)
  const hireVehicles = await readJson('car_hire_vehicles.json', []);
  if (hireVehicles.length === 0) {
    const initialHire = [
      {
        id: 'hire-01',
        name: 'Toyota Allion 2021',
        type: 'Sedan',
        capacity: 4,
        luggageCapacity: '2 Bags',
        ac: true,
        baseFare: 2200,
        fareBasis: 'Per Day / Trip in Sylhet City',
        features: ['Professional Driver', 'Air Conditioned', 'Clean Interior', 'Fuel Included'],
        image: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80',
        description: 'Smooth and fuel-efficient sedan with courteous driver for city tours, wedding travels, or airport drops.',
      },
      {
        id: 'hire-02',
        name: 'Toyota Noah Super GL',
        type: 'Microbus',
        capacity: 7,
        luggageCapacity: '5 Bags',
        ac: true,
        baseFare: 3800,
        fareBasis: 'Per Trip / Jaflong / Ratargul',
        features: ['Experienced Highway Driver', 'Dual A/C', 'Foldable Seats', 'Ample Luggage'],
        image: 'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?auto=format&fit=crop&w=800&q=80',
        description: 'Spacious family microbus suited for scenic day tours to Ratargul Swamp Forest, Jaflong, or Bisnakandi.',
      },
      {
        id: 'hire-03',
        name: 'Toyota Hiace Grand Cabin',
        type: 'Microbus',
        capacity: 12,
        luggageCapacity: '8 Bags',
        ac: true,
        baseFare: 4500,
        fareBasis: 'Group Journeys & Corporate Trips',
        features: ['High Roof Cabin', 'Chilled Dual A/C', 'Experienced Driver', 'PA Audio System'],
        image: 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=800&q=80',
        description: 'Large passenger van for group outings, university study tours, and wedding parties in Sylhet division.',
      },
      {
        id: 'hire-04',
        name: 'Mitsubishi Pajero Sport',
        type: 'SUV',
        capacity: 7,
        luggageCapacity: '4 Bags',
        ac: true,
        baseFare: 5200,
        fareBasis: 'Luxury Executive Trip',
        features: ['Chauffeur in Uniform', 'Leather Seats', '4WD Terrain Capability', 'Premium Sound'],
        image: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=800&q=80',
        description: 'Rugged yet luxurious 4x4 SUV suitable for hilly tea garden excursions in Sreemangal and luxury travels.',
      },
    ];
    await writeJson('car_hire_vehicles.json', initialHire);
    console.log('[Seed] Car hire vehicles seeded.');
  }

  // 4. Seed Car Rental Vehicles (Daily Rental)
  const rentalVehicles = await readJson('rental_vehicles.json', []);
  if (rentalVehicles.length === 0) {
    const initialRental = [
      {
        id: 'rent-01',
        name: 'Toyota Corolla Cross',
        category: 'Compact SUV',
        capacity: 5,
        dailyPrice: 4500,
        transmission: 'Automatic',
        fuelType: 'Hybrid / Petrol',
        mileageLimit: '150 km/day',
        depositAmount: 10000,
        conditions: 'Valid NID and Driving License required. Fuel paid by renter.',
        image: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=800&q=80',
        description: 'Modern hybrid crossover SUV delivering high ground clearance, supreme comfort, and great fuel economy.',
      },
      {
        id: 'rent-02',
        name: 'Toyota Premio 1.5X',
        category: 'Sedan',
        capacity: 5,
        dailyPrice: 3200,
        transmission: 'Automatic',
        fuelType: 'Octane',
        mileageLimit: '180 km/day',
        depositAmount: 8000,
        conditions: 'Minimum driver age 21. City and regional use permitted.',
        image: 'https://images.unsplash.com/photo-1590362891991-f776e747a588?auto=format&fit=crop&w=800&q=80',
        description: 'Elegant executive Japanese sedan offering smooth suspension, wood-trim interior, and plush seating.',
      },
      {
        id: 'rent-03',
        name: 'Honda Vezel Hybrid Z',
        category: 'SUV',
        capacity: 5,
        dailyPrice: 3800,
        transmission: 'Automatic',
        fuelType: 'Hybrid',
        mileageLimit: '160 km/day',
        depositAmount: 9000,
        conditions: 'Self-drive or with-driver available. Pre-inspection mandatory.',
        image: 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?auto=format&fit=crop&w=800&q=80',
        description: 'Sporty hybrid crossover with sporty steering feel, eco mode, and ample boot space for luggage.',
      },
      {
        id: 'rent-04',
        name: 'Toyota Land Cruiser Prado TX',
        category: 'Luxury SUV',
        capacity: 7,
        dailyPrice: 8500,
        transmission: 'Automatic 4WD',
        fuelType: 'Diesel',
        mileageLimit: '200 km/day',
        depositAmount: 20000,
        conditions: 'Corporate and VIP hire. Driver option highly recommended.',
        image: 'https://images.unsplash.com/photo-1541348263662-e0c8de4259ba?auto=format&fit=crop&w=800&q=80',
        description: 'Dominant 4-wheel drive luxury SUV built to conquer any terrain with executive status and comfort.',
      },
    ];
    await writeJson('rental_vehicles.json', initialRental);
    console.log('[Seed] Rental vehicles seeded.');
  }

  // 5. Seed Initial Demo Bookings (ongoing, completed, cancelled) for the demo user
  const bookings = await readJson('bookings.json', []);
  if (bookings.length === 0) {
    const demoBookings = [
      {
        id: 'BK-7A9B-0101',
        userId: 'usr_demo_1001',
        userName: 'Jhon Martin',
        userEmail: 'demo@parksyl.com',
        parkingId: 'prk-001',
        parkingName: 'Premier City Center Parking',
        parkingArea: 'Zindabazar',
        parkingAddress: '202 Zindabazar Point, Sylhet City',
        parkingImage: 'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?auto=format&fit=crop&w=800&q=80',
        pricePerHour: 40,
        vehicleType: 'Car',
        vehiclePlate: 'Sylhet-Ga 11-2045',
        bookingDate: '2026-11-08',
        startTime: '10:00 AM',
        endTime: '01:00 PM',
        durationHours: 3,
        totalPrice: 120,
        status: 'ongoing',
        createdAt: new Date().toISOString(),
        isDemo: true,
      },
      {
        id: 'BK-4C2E-0098',
        userId: 'usr_demo_1001',
        userName: 'Jhon Martin',
        userEmail: 'demo@parksyl.com',
        parkingId: 'prk-002',
        parkingName: 'MetroPark Master Point',
        parkingArea: 'Amberkhana',
        parkingAddress: 'Amberkhana Main Roundabout, Sylhet',
        parkingImage: 'https://images.unsplash.com/photo-1590674899484-d5640e854abe?auto=format&fit=crop&w=800&q=80',
        pricePerHour: 35,
        vehicleType: 'Car',
        vehiclePlate: 'Sylhet-Ga 11-2045',
        bookingDate: '2026-11-05',
        startTime: '02:00 PM',
        endTime: '04:00 PM',
        durationHours: 2,
        totalPrice: 70,
        status: 'completed',
        createdAt: new Date(Date.now() - 172800000).toISOString(),
        isDemo: true,
      },
      {
        id: 'BK-1D8F-0085',
        userId: 'usr_demo_1001',
        userName: 'Jhon Martin',
        userEmail: 'demo@parksyl.com',
        parkingId: 'prk-003',
        parkingName: 'DriveGuard Solutions Hub',
        parkingArea: 'Subidbazar',
        parkingAddress: 'Subidbazar High School Road, Sylhet',
        parkingImage: 'https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?auto=format&fit=crop&w=800&q=80',
        pricePerHour: 30,
        vehicleType: 'Car',
        vehiclePlate: 'Sylhet-Ga 11-2045',
        bookingDate: '2026-11-03',
        startTime: '11:00 AM',
        endTime: '01:00 PM',
        durationHours: 2,
        totalPrice: 60,
        status: 'cancelled',
        createdAt: new Date(Date.now() - 345600000).toISOString(),
        isDemo: true,
      },
    ];
    await writeJson('bookings.json', demoBookings);
    console.log('[Seed] Demo bookings seeded.');
  }

  // 6. Seed Favorites
  const favorites = await readJson('favorites.json', []);
  if (favorites.length === 0) {
    favorites.push({
      userId: 'usr_demo_1001',
      parkingIds: ['prk-001', 'prk-002'],
    });
    await writeJson('favorites.json', favorites);
    console.log('[Seed] Initial user favorites seeded.');
  }
}

if (require.main === module) {
  seedInitialData().then(() => {
    console.log('Database-less JSON seed complete.');
    process.exit(0);
  });
}

module.exports = { seedInitialData };
