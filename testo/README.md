# Mini Ecommerce - Day 1 to Day 3

## Description
Flutter mini-ecommerce app with incremental daily progress.

---

## Day 1
- Project setup
- Dependencies (Riverpod, Dio, SharedPreferences, GoRouter)
- Auth screens (Login/Register)
- Mock API integration with JWT token persistence

---

## Day 2
- Catalog screen: Grid/List of products
- Product details screen with:
  - Name, price, stock, image
  - Add/remove quantity to cart
- Cart screen basics:
  - Items added, quantity updates, subtotal
- Out-of-stock handling: disable add-to-cart button
- Basic error handling with SnackBars

---

- Place Order flow:
  - Cart checkout with “Place Order” button
  - Orders screen for users with order ID, date, total

---

## How to Run
1. Clone repo
2. Run `flutter pub get`
3. Run `flutter run`

---

## State Management
Riverpod
**Reason for choice:**  
- Simple and easy to learn compared to alternatives like Bloc  
- Provides clear separation between UI and state logic  
- Supports both synchronous and asynchronous state  
- Scales well as the app grows (modular and testable)  
- Good community support and frequent updates
---

## Assumptions
- Mock API, JWT token stored locally
- Login works only for `test@test.com / 1234` unless registration implemented
- Orders and products stored in memory (reset on app restart)

---

## Trade-offs
- No real backend, using mock data
- Limited error handling (basic SnackBars for now)
- Skeletons/shimmers not yet implemented

