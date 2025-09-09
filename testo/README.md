# Mini Ecommerce - Day 1 to Day 5
## Description

Flutter mini-ecommerce app with authentication, product catalog, cart, orders, and admin features. Includes modern UX improvements, password/email validation, show/hide password, and edge-case handling. Mock backend with in-memory storage and JWT token persistence.

### Day 1

Project setup

Dependencies (Riverpod, Dio, SharedPreferences, GoRouter)

Auth screens (Login/Register)

Modern vertical card UI

Blue theme with white button text

Email & password validation:

Email must contain @ and valid format

Password: min 8 chars, at least one letter, one number, one symbol

Confirm password validation

Show/hide password icons for better UX

Mock API integration with JWT token persistence

###  Day 2 & 3

Catalog screen: Grid/List of products

Product details screen with:

Name, price, stock, image

Add/remove quantity to cart

Cart screen basics:

Items added, quantity updates, subtotal

Out-of-stock handling: disable add-to-cart button

Basic error handling with SnackBars

Place Order flow:

Cart checkout with “Place Order” button

Orders screen for users with order ID, date, total

Persisted token logout + session clear

Admin Home with tabs:

Add Product (with validation)

All Orders (paginated list with totals)

Low Stock (<5 items) highlighted

UX & Edge Cases:

Pull-to-refresh on catalog and orders

Skeleton loaders (future improvement)

Better empty states (cart, catalog, orders)

Snackbar for errors and network issues

Out-of-stock: disabled Add-to-Cart with message

Race condition handling: stock mismatch when placing orders

Auth expiry: clear token and redirect to login

## Generated Plugin Files

Flutter auto-generates these for platform plugins:

linux/flutter/generated_plugin_registrant.*

windows/flutter/generated_plugin_registrant.*

macos/Flutter/GeneratedPluginRegistrant.swift

Included in this repo to ensure out-of-the-box build on all platforms.

## How to Run

Clone repo

Run flutter pub get

Run flutter run

## State Management

Riverpod
Reason for choice:

Simple and easy to learn compared to Bloc

Clear separation of UI and state logic

Handles both sync & async state cleanly

Modular, testable, and scalable as app grows

Strong community support and updates

## Assumptions

Mock API, JWT token stored locally

Orders and products stored in memory (reset on restart)

## Trade-offs

No real backend (mock only)

Limited test coverage (only unit + one widget test planned)

Skeletons/shimmers not fully implemented yet