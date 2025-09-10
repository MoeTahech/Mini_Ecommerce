import '../../cart/data/cart_item.dart';

class Order {
  final int id;
  final List<CartItem> items;
  final DateTime date;
  final double total;

  Order({
    required this.id,
    required this.items,
    required this.date,
    required this.total,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List? ?? [];
    final items = itemsJson
        .map((i) => CartItem.fromJson(i as Map<String, dynamic>))
        .toList();

    return Order(
      id: json['id'] as int,
      items: items,
      date: DateTime.parse(json['createdAt'] as String),
      total: (json['total'] as num).toDouble(),
    );
  }
}
