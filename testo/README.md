# Mini Ecommerce - Day 1 to Day 5

## Description

Flutter mini-ecommerce app with authentication, product catalog, cart, orders, and admin features. Includes modern UX improvements, password/email validation, show/hide password, edge-case handling, and a cohesive blue-themed UI. Mock backend with in-memory storage and JWT token persistence.

---

### Day 1

**Project setup**

- Dependencies: Riverpod, Dio, SharedPreferences, GoRouter
- Auth screens: Login/Register (fully working with Spring Boot backend)
- Modern vertical card UI
- Blue theme with white button text
- Email & password validation:
  - Email must contain `@` and valid format
  - Password: min 8 chars, at least one letter, one number, one symbol
  - Confirm password validation
- Show/hide password icons for better UX
- JWT token persistence after successful login/register
---

### Day 2 & 3

**Catalog screen**

- Grid/List of products with modern cards
- Pull-to-refresh support
- Skeleton loaders placeholders for loading state
- Empty state handling with friendly message
- Out-of-stock badge displayed on products

**Product details screen**

- Name, price, stock, image
- Blue-themed layout
- Add/remove quantity to cart
- Add to cart button disables when out-of-stock
- Snackbars for success/error messages

**Cart screen**

- Items added, quantity updates, subtotal
- Place Order flow with modern "Place Order" button
- Out-of-stock handling
- Total includes taxes if applicable

**Orders screen**

- Shows order ID, date, total
- Items listed with quantities
- Clear empty states and skeletons for loading

**Admin Home**

- Tabs: Add Product, All Orders, Low Stock
- Modern form design with validation
- All Orders tab: shows order list with totals
- Low Stock tab: highlights items with stock < 5

---

### UX & Edge Cases

- Consistent blue-themed modern design across all screens
- Pull-to-refresh on catalog and orders
- Skeleton loaders (future improvement)
- Better empty states (cart, catalog, orders)
- Snackbar for errors and network issues
- Out-of-stock: disabled Add-to-Cart with message
- Race condition handling: stock mismatch when placing orders
- Auth expiry: clear token and redirect to login
- Home, Catalog, Product Details, Cart, Orders, and Admin screens now match Login/Register styling

---

## Generated Plugin Files

Flutter auto-generates these for platform plugins:

- linux/flutter/generated_plugin_registrant.*
- windows/flutter/generated_plugin_registrant.*
- macos/Flutter/GeneratedPluginRegistrant.swift

> ⚠️ These are excluded from this commit to keep repo clean.

---

## How to Run

- Clone repo
- Run `flutter pub get`
- Run `flutter run`

---

## State Management

**Riverpod**

- Simple and easy to learn compared to Bloc
- Clear separation of UI and state logic
- Handles both sync & async state cleanly
- Modular, testable, and scalable as app grows
- Strong community support and updates

---

## Assumptions

- Mock API, JWT token stored locally
- Orders and products stored in memory (reset on restart)

---

## Trade-offs

- No real backend (mock only)
- Limited test coverage (only unit + one widget test planned)
- Skeletons/shimmers not fully implemented yet
