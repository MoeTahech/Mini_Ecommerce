### Mini Ecommerce - Day 1 to Day 5

### Description
Flutter mini-ecommerce app with authentication, product catalog, cart, orders, and admin features. Includes modern UX improvements, password/email validation, show/hide password, edge-case handling, and a cohesive blue-themed UI. Backend is Spring Boot with JWT authentication and Spring Security, fully integrated with catalog and product details screens, tested using H2 database.

### Day 1

#### Project setup
- Dependencies: Riverpod, Dio, SharedPreferences
- Auth screens: Login/Register (fully working with Spring Boot backend)
- Modern vertical card UI
- Blue theme with white button text

#### Email & password validation
- Email must contain `@` and valid format
- Password: min 8 chars, at least one letter, one number, one symbol
- Confirm password validation
- Show/hide password icons for better UX
- JWT token persistence after successful login/register
- Session management for user authentication

### Day 2 & 3

#### Catalog screen
- Grid/List of products with modern cards
- Pull-to-refresh support
- Empty state handling with friendly message
- Out-of-stock badge displayed on products
- Product details button for navigation
- Tested by inserting products directly into H2 database

#### Product details screen
- Name, price, stock, image
- Blue-themed layout
- Add/remove quantity to cart
- Add to cart button disables when out-of-stock
- Snackbars for success/error messages

#### Cart screen
- Items added, quantity updates, subtotal, total (including tax)
- Place Order flow with backend integration (`POST /orders`)
- Out-of-stock handling
- Total includes taxes if applicable

#### Orders screen
- Shows order ID, date, total
- Items listed with quantities
- Pull-to-refresh for updated orders
- Empty state handled gracefully
- Items count removed in the summary for clarity

#### Admin Home
- Tabs: Add Product, All Orders, Low Stock
- Modern form design with validation
- All Orders tab: shows order list with totals
- Low Stock tab: highlights items with stock < 5
- Fully integrated with backend endpoints (`/products`, `/admin/orders`, `/admin/low-stock`)

### UX & Edge Cases
- Consistent blue-themed modern design across all screens
- Pull-to-refresh on catalog and orders
- Better empty states (cart, catalog, orders)
- Snackbars for errors and network issues
- Out-of-stock: disabled Add-to-Cart with message
- Race condition handling: stock mismatch when placing orders
- Auth expiry: clear token and redirect to login
- Home, Catalog, Product Details, Cart, Orders, and Admin screens now match Login/Register styling
- Catalog and Product Details screens fully working with backend and tested via H2 database
- Admin screens fully working with product creation, listing, low-stock view, and order management

### Backend Integration
- Spring Boot + H2 Database
- Endpoints implemented:
  - `/auth/register`, `/auth/login`
  - `/products` (GET/POST)
  - `/orders` (GET `/orders/me`, POST `/orders`)
  - `/admin/orders`
  - `/admin/low-stock`
- JWT Authentication with Spring Security
- Spring Security Config:
  - Protected endpoints for authenticated users
  - Admin-only endpoints protected with roles
  - JWT filter validates token for requests
  - `/auth/**` endpoints publicly accessible

### State Management
- Riverpod
  - Simple and easy to learn compared to Bloc
  - Clear separation of UI and state logic
  - Handles both sync & async state cleanly
  - Modular, testable, and scalable as app grows
  - Strong community support and updates

### Assumptions
- Backend is Spring Boot with H2 database
- JWT token stored locally
- Orders and products persist in H2 database (reset on restart)
- Catalog and Product Details tested by inserting products into H2
- Admin user role required for product management

### Trade-offs
- Mock API replaced with Spring Boot backend
- Limited test coverage (unit + widget test)
- Skeletons/shimmers not fully implemented yet
- Base URL hardcoded (`http://localhost:8080`) instead of using `.env` file

### How to Run
- Clone repo
- Run `flutter pub get`
- Start Spring Boot backend (H2 database, http://localhost:8080)
- Run `flutter run` on your device/emulator
