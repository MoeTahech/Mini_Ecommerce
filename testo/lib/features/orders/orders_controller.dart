import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/orders/data/order_model.dart';
import '../../features/cart/data/cart_item.dart';

final ordersProvider =
    StateNotifierProvider<OrdersController, List<Order>>(
        (ref) => OrdersController());

class OrdersController extends StateNotifier<List<Order>> {
  OrdersController() : super([]);

  void addOrder(List<CartItem> cartItems, double total) {
    if (cartItems.isEmpty) return; // prevent empty orders

    // Compute total if the passed value is 0 or negative
    final double orderTotal = total <= 0
        ? cartItems.fold(0, (sum, item) => sum + item.product.price * item.quantity)
        : total;

    final newOrder = Order(
      id: state.isEmpty ? 1 : state.last.id + 1,
      items: cartItems,
      total: orderTotal,
      date: DateTime.now(),
    );

    state = [...state, newOrder];
  }
}

