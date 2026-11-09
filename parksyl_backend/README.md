# SylPark Local REST API (Backend)

Local Node.js + Express REST API with file-based JSON storage (database-less architecture).

## Overview
- **Host Binding:** `0.0.0.0`
- **Default Port:** `3000`
- **Storage:** Pure JSON files in `./data/`
- **Authentication:** JSON Web Tokens (JWT) & bcryptjs
- **Location Context:** Sylhet City, Bangladesh (Currency: ৳ BDT)

## Getting Started

1. **Install dependencies:**
   ```bash
   npm install
   ```
2. **Run automated API verification test suite:**
   ```bash
   npm test
   ```
   *(Executes `node src/test.js` validating all 13 REST endpoints).*
3. **Start backend server:**
   ```bash
   npm run dev
   ```

## Private Data Files
All application state is stored safely in `./data/`:
- `users.json`: Registered users, bcrypt password hashes, profile details.
- `parking.json`: Sylhet parking locations, coordinates, spots, rates, and facilities.
- `bookings.json`: Parking reservations and cancellation logs.
- `car_hire_vehicles.json`: Chauffeur journey vehicles.
- `car_hire_bookings.json`: Journey bookings.
- `rental_vehicles.json`: Daily rental fleet.
- `rental_bookings.json`: Vehicle rental reservations.
- `favorites.json`: User parking favorites.

## Demo Account
- **Email:** `demo@parksyl.com`
- **Password:** `Password123!`
