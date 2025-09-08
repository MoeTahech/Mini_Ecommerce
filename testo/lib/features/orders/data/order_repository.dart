import 'order_model.dart';
import '../../cart/data/cart_item.dart';

class OrderRepository {
  final List<Order> _orders = [];

  List<Order> getOrders() => _orders;

  void addOrder(List<CartItem> items, double total) {
    _orders.add(
      Order(
        id: _orders.length + 1,
        items: List.from(items),
        total: total,
        date: DateTime.now(),
      ),
    );
  }
}
