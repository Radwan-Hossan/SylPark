# SylPark (ParkSyl) — Smart Parking, Car Hire & Vehicle Rental in Sylhet

**SylPark** is a complete, production-grade Flutter Android mobile application paired with a local Node.js + Express REST API backend. It is designed for discovering parking spaces across **Sylhet City, Bangladesh**, reserving parking slots, and booking journey **Car Hire** (with driver) and daily **Car Rental** services.

> **Academic Demonstration Notice:**  
> This application is built for an academic university project presentation. All coordinates, parking facilities, pricing, and live availability statuses represent curated demo data. Data is persistently stored in private JSON files inside the backend—**no external database or cloud service is required**.

---

## 📱 Visual Design System (Reference UI)

The UI was crafted by following the provided mobile UI design references:
- **Palette:** Obsidian Dark (`#111625`), Emerald Accent (`#10B981` / `#059669`), and Crisp Surface (`#FFFFFF` with `#E2E8F0` borders).
- **Navigation:** Custom floating dark capsule navbar (`#111625`) with active item enclosed in a white capsule (`#FFFFFF`) with dark text and icon.
- **Card Styling:** Rounded corners (`18–24px`), thumbnail on left, clear badge tags, ratings, and dual pill action buttons.
- **Booking Tabs:** Segmented pill toggle control for *Ongoing*, *Completed*, and *Cancelled* reservations.
- **Account Screen:** Dark header banner, user profile avatar, clean setting cards with chevron arrows, and server connection manager.

---

## 🛠️ Technology Stack

### Frontend (Flutter Mobile App)
- **Framework:** Flutter & Dart
- **State Management:** Provider (`MultiProvider` for Auth, Parking, Bookings, Car Hire, Car Rental)
- **Networking:** `http` package with centralized `ApiClient` (automatic Bearer JWT injection and error handlers)
- **Map:** `flutter_map` with OpenStreetMap raster tiles centered on Sylhet (`24.8949, 91.8687`)
- **Local Storage:** `shared_preferences` (persisting JWT tokens and dynamic host IP settings)
- **Formatting:** `intl`

### Backend (Local REST API)
- **Runtime:** Node.js (v20+)
- **Framework:** Express.js (v4)
- **Authentication:** JSON Web Tokens (`jsonwebtoken`) with 30-day validity
- **Security:** `bcryptjs` for password hashing
- **CORS:** Cross-Origin Resource Sharing enabled for local network devices
- **Storage:** **Pure JSON file storage** (`parksyl_backend/data/*.json`) with safe atomic writes. **Zero databases (No MongoDB, No SQLite, No Firebase, No MySQL).**

---

## 📁 Project Folder Structure

```text
sylpark/
│
├── lib/
│   ├── main.dart                          # App entry point (initializes ApiConfig)
│   ├── app.dart                           # MultiProvider setup & theme routing
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_config.dart            # Centralized API URLs & IP switcher
│   │   │   ├── app_colors.dart            # Color tokens from UI references
│   │   │   └── app_constants.dart         # Sylhet zones, coordinates, currency (৳)
│   │   └── theme/
│   │       └── app_theme.dart             # Material 3 custom light theme
│   │
│   ├── models/                            # Clean Dart data models
│   │   ├── user_model.dart
│   │   ├── parking_model.dart
│   │   ├── booking_model.dart
│   │   ├── car_hire_model.dart
│   │   └── car_rental_model.dart
│   │
│   ├── services/                          # API communication services
│   │   ├── api/api_client.dart            # HTTP client with JWT injection
│   │   ├── auth/auth_service.dart
│   │   ├── parking/parking_service.dart
│   │   ├── bookings/booking_service.dart
│   │   ├── car_hire/car_hire_service.dart
│   │   └── car_rental/car_rental_service.dart
│   │
│   ├── providers/                         # State management
│   │   ├── auth_provider.dart
│   │   ├── parking_provider.dart
│   │   ├── booking_provider.dart
│   │   ├── car_hire_provider.dart
│   │   └── car_rental_provider.dart
│   │
│   ├── screens/                           # Screen UI modules
│   │   ├── splash/splash_screen.dart
│   │   ├── auth/                          # Welcome, Login, Register, Forgot Password
│   │   ├── home/home_screen.dart          # Main dashboard & quick shortcuts
│   │   ├── parking/                       # Explore, Filter, Search, Details
│   │   ├── map/sylhet_map_screen.dart     # Interactive Sylhet OpenStreetMap
│   │   ├── bookings/                      # Booking flow, Digital Pass, My Bookings
│   │   ├── car_hire/                      # Journey hire fleet, request form, history
│   │   ├── car_rental/                    # Daily rental fleet, request form, history
│   │   ├── services/services_hub_screen.dart # Switcher for Hire & Rental
│   │   ├── profile/                       # User profile, IP server settings, favorites
│   │   └── navigation/main_navigation_screen.dart
│   │
│   └── widgets/                           # Reusable UI components
│       ├── cards/                         # ParkingCard, BookingCard, CarHireCard, CarRentalCard
│       ├── common/                        # CustomButton, CustomTextField, EmptyState
│       └── navigation/                    # CustomFloatingNavBar (matching reference)
│
├── parksyl_backend/                       # Local Node.js Express REST API
│   ├── src/
│   │   ├── config/constants.js
│   │   ├── controllers/                   # Auth, User, Parking, Booking, Hire, Rental
│   │   ├── middleware/auth.js             # Bearer JWT middleware
│   │   ├── routes/                        # Express routers
│   │   ├── utils/fileStorage.js           # Safe JSON read/write engine
│   │   ├── utils/seed.js                  # Initial demo data & accounts
│   │   ├── test.js                        # 13 automated endpoint tests
│   │   ├── app.js
│   │   └── server.js                      # Listens on 0.0.0.0:3000
│   │
│   ├── data/                              # Persistent private JSON storage
│   │   ├── users.json
│   │   ├── parking.json
│   │   ├── bookings.json
│   │   ├── car_hire_vehicles.json
│   │   ├── car_hire_bookings.json
│   │   ├── rental_vehicles.json
│   │   ├── rental_bookings.json
│   │   └── favorites.json
│   │
│   ├── .env.example
│   ├── .env
│   ├── package.json
│   └── README.md
│
├── README.md
└── DEVELOPMENT_PROGRESS.md
```

---

## 🔑 Pre-Seeded Demonstration Account

You can log in to demonstrate the application to your teacher with these credentials:

| Field | Value |
| :--- | :--- |
| **Email** | `demo@parksyl.com` |
| **Password** | `Password123!` |
| **Name** | `Jhon Martin` |
| **Phone** | `+880 1712 345678` |

> 💡 **Quick Access:** On the app's Welcome ("Let's get started") screen, tap the green **"Demo Teacher Instant Access"** button to log in immediately without typing!

---

## 🚀 Step-by-Step Setup Guide

### 1. Prerequisites
- **Node.js:** v18.0.0 or higher
- **Flutter SDK:** v3.19 or higher
- **Android Phone or Emulator**

---

### 2. Start the Local Backend Server

1. Open PowerShell or Terminal and navigate to the backend directory:
   ```bash
   cd parksyl_backend
   ```
2. Install dependencies (if not already installed):
   ```bash
   npm install
   ```
3. Run the automated REST verification tests:
   ```bash
   node src/test.js
   ```
   *(All 13 tests should pass).*
4. Start the Express server:
   ```bash
   npm run dev
   ```
   The backend will display:
   ```text
   ========================================================
     SylPark Local Backend Server Running
     - Local URL:        http://localhost:3000/api/health
     - Android Emulator: http://10.0.2.2:3000/api/health
     - Host Binding:     0.0.0.0:3000
     - Data Directory:   JSON Files (No Database)
   ========================================================
   ```

---

### 3. Connect Physical Android Phone (Wi-Fi Setup)

When running the app on a physical Android phone, the phone communicates directly with your laptop's Express server over your Wi-Fi network.

#### Step 1: Same Wi-Fi Connection
Connect your laptop and your Android phone to the **same Wi-Fi router / mobile hotspot**.

#### Step 2: Find Laptop IPv4 Address
1. On your Windows laptop, open PowerShell and run:
   ```powershell
   ipconfig
   ```
2. Look under **Wireless LAN adapter Wi-Fi** for:
   ```text
   IPv4 Address . . . . . . . . . . . : 192.168.0.109
   ```

#### Step 3: Windows Firewall Permission (Port 3000)
Make sure Windows Firewall allows inbound connections on port 3000:
1. Press `Win + R`, type `wf.msc` and press Enter.
2. Click **Inbound Rules** > **New Rule...**
3. Select **Port** > **TCP** > Specific local ports: `3000`.
4. Allow the connection on **Private networks**.

#### Step 4: Verify in Phone Browser
Open your Android phone's web browser (Chrome) and navigate to:
```text
http://192.168.0.109:3000/api/health
```
You should see:
```json
{
  "status": "ok",
  "app": "SylPark Local REST API",
  "location": "Sylhet City, Bangladesh"
}
```

#### Step 5: Change Host IP Directly Inside the App
You can change the server IP inside the app anytime without rebuilding:
- Tap the **Settings icon** at the top right of the Welcome Screen, OR
- Go to **Account** > **API Server Connection (Change IP)**.
- Type your laptop's IPv4 address and tap **Test Health API** followed by **Save Endpoint**.

---

### 4. Run the Flutter Mobile App

1. In the root directory:
   ```bash
   flutter pub get
   ```
2. Check for any analysis warnings:
   ```bash
   flutter analyze
   ```
3. Run widget tests:
   ```bash
   flutter test
   ```
4. Connect your phone via USB (with USB Debugging enabled) or start an Android Emulator, then run:
   ```bash
   flutter run
   ```

---

## 📋 Complete REST API Endpoints

| Method | Endpoint | Description | Auth Required |
| :--- | :--- | :--- | :---: |
| `GET` | `/api/health` | Backend status & demo info | No |
| `POST` | `/api/auth/register` | Register new user | No |
| `POST` | `/api/auth/login` | Login user & return JWT token | No |
| `GET` | `/api/auth/me` | Fetch active user session | Yes |
| `GET` | `/api/users/me` | Get profile details | Yes |
| `PUT` | `/api/users/me` | Update profile / vehicle info | Yes |
| `GET` | `/api/parking` | List parking spots with filters | No |
| `GET` | `/api/parking/search` | Search parking spots by query | No |
| `GET` | `/api/parking/:id` | Get parking details | No |
| `GET` | `/api/favorites` | Get user's saved favorites | Yes |
| `POST` | `/api/favorites` | Add parking spot to favorites | Yes |
| `DELETE` | `/api/favorites/:id` | Remove from favorites | Yes |
| `POST` | `/api/bookings` | Create new parking reservation | Yes |
| `GET` | `/api/bookings` | List user's reservations | Yes |
| `GET` | `/api/bookings/:id` | Get reservation details | Yes |
| `PATCH` | `/api/bookings/:id/cancel`| Cancel active parking reservation | Yes |
| `GET` | `/api/car-hire` | List chauffeur vehicles | No |
| `GET` | `/api/car-hire/:id` | Get hire vehicle specs | No |
| `POST` | `/api/car-hire/bookings`| Request car hire journey | Yes |
| `GET` | `/api/car-hire/bookings/my`| View user's journey requests | Yes |
| `GET` | `/api/car-rental` | List daily rental vehicles | No |
| `GET` | `/api/car-rental/:id` | Get rental vehicle details | No |
| `POST` | `/api/car-rental/bookings`| Request daily car rental | Yes |
| `GET` | `/api/car-rental/bookings/my`| View user's rental reservations| Yes |

---

## 👨‍🏫 Teacher Demonstration Checklist

When presenting to your teacher:
1. **Explain the Architecture:** Point out the separation between Flutter and Node.js REST API with database-less JSON persistence.
2. **Demonstrate Sign-In:** Tap "Demo Teacher Instant Access" or use `demo@parksyl.com`.
3. **Explore Sylhet Parking:** Show the 7 pre-seeded Sylhet areas (Zindabazar, Amberkhana, Mirabazar, etc.) and filter by vehicle or area.
4. **Interactive Map:** Open the Sylhet map, tap pins to show summary cards, and open full details.
5. **Reserve a Parking Slot:** Book a space at Zindabazar Point, pick a duration, and showcase the generated digital ticket pass with barcode.
6. **Manage Bookings:** Navigate to the "Booking" tab and demonstrate switching between **Ongoing**, **Completed**, and **Cancelled** tabs; cancel an active booking.
7. **Demonstrate Car Services:**
   - **Car Hire:** Browse chauffeur vehicles (Hiace, Noah, Pajero) and submit a journey request.
   - **Car Rental:** Select a vehicle for daily self-drive or driver rental and review the live daily pricing calculation.
8. **Network Connection Proof:** Open Account > API Server Connection, show the laptop IPv4 address, and tap **"Test Health API"** to prove live local client-server network communication!
#   P a r k S y l  
 