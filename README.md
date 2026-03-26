# ✂️ Salon Booking App

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-State%20Management-blue)

A modern, highly-interactive mobile application built with **Flutter** for managing salon appointments, barbers, and specialized services. Designed with a **Feature-First Architecture** and a highly polished UI.

---

## ✨ Key Features

### 📅 Smart Booking Flow (Customer)
* **Barber Selection**: Beautifully designed barber cards with **Hero animations** transitioning smoothly to the booking screen.
* **Dynamic Time Slots**: Interactive and color-coded time slot grid to clearly define available (Green), booked (Grey), and selected (Blue) slots.
* **Fluid UI/UX**: Immersive **Shimmer loading effects** while fetching data, substituting the traditional boring loaders.

### 🛡️ Admin Dashboard (Management)
* **Real-time KPI Metrics**: A row of interactive cards tracking Daily Income, Active Appointments, and Total Bookings.
* **Interactive Timeline View**: An organized list displaying daily customer appointments using clean `ListTile` containers. 
* **Barber & Service Management**: 
  * Add, Edit, or Delete barbers and salon services effortlessly.
  * **Swipe-to-Delete** (`Dismissible`) with intuitive confirmation dialogs.
  * Professionally designed **Empty States** when no data is available.

### 🎨 Design System & Aesthetics
* Built upon a **Custom Centralized Theme** via `app_theme.dart`.
* Typography leverages the beautiful **Cairo Font** for modern Arabic UI support.
* Unified 8px spacing models, rounded borders (12px), and a meticulously curated color palette (Dark Theme optimized).

---

## 🏗️ Architecture & Tech Stack

This project follows a strict **Feature-First Architecture** (Domain-Driven Design), organizing the codebase into scalable and isolated modules:
* `lib/core/`: Global widgets, central app theme, layout helpers.
* `lib/features/auth/`: Authentication logic and customized login screens.
* `lib/features/booking/`: Customer-facing interactions, time tables, and selections.
* `lib/features/dashboard/`: Admin tracking screens, service manipulations, and timeline tracking.

**Dependencies:**
* `flutter_riverpod`: Modern and safe state management.
* `shimmer`: Beautiful skeleton loaders to enhance perceived performance.
* `material`: Built strictly adhering to the Material Design System but significantly customized.

---

## 🚀 Getting Started

To run this project on your local machine, follow these steps:

### Prerequisites:
* [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version recommended)
* [Dart SDK](https://dart.dev/get-dart)
* Android Studio / VS Code with required Flutter extensions.

### Installation & Run:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/abdullahikhmaies/salon-booking-app.git
   cd salon-booking-app
   ```

2. **Fetch all dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## 💡 Upcoming Roadmap
- [ ] Connect Authentication and Database to **Firebase**.
- [ ] Implement integrated Online Payment Gateways (Stripe/PayPal).
- [ ] Add Push Notifications for appointment confirmations and marketing.

---
**Developed with ❤️ by [Abdullah Ikhmaies](https://github.com/abdullahikhmaies)**
