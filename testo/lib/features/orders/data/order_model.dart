import '../../cart/data/cart_item.dart';

class Order {
  final int id;
  final List<CartItem> items;
  final DateTime date;

  // Global tax rate (e.g., 10%)
  static const double taxRate = 0.10;

double get total {
  final subtotal = items.fold(
      0.0, (double sum, item) => sum + item.product.price * item.quantity);
  return subtotal * (1 + taxRate);
}

  Order({
    required this.id,
    required this.items,
    required this.date,
    double? total, // optional for backward compatibility
  });
}
