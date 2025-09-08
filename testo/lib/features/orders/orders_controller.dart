import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/orders/data/order_model.dart';
import '../../features/cart/data/cart_item.dart';

final ordersProvider =
    StateNotifierProvider<OrdersController, List<Order>>((ref) => OrdersController());

class OrdersController extends StateNotifier<List<Order>> {
  OrdersController() : super([]);

  void addOrder(List<CartItem> cartItems, double total) {
    final newOrder = Order(
      id: state.isEmpty ? 1 : state.last.id + 1,
      items: cartItems,
      total: total,
      date: DateTime.now(),
    );
    state = [...state, newOrder];
  }
}
