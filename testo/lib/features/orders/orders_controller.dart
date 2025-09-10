import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/orders/data/order_model.dart' as models;
import '../cart/data/cart_item.dart';
import '../../../core/api_client.dart';
import '../../../core/session.dart';

final ordersProvider =
    StateNotifierProvider<OrdersController, List<models.Order>>(
        (ref) => OrdersController(ref));

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient("http://localhost:8080"); // adjust your baseUrl
});

class OrdersController extends StateNotifier<List<models.Order>> {
  final Ref ref;
  OrdersController(this.ref) : super([]);

  Future<void> fetchUserOrders() async {
    final token = await Session.getToken();
    if (token == null) throw Exception("User not logged in");

    final api = ref.read(apiClientProvider);
    api.setToken(token);

    final response = await api.get('/orders/me');

    if (response.statusCode == 200) {
      final data = response.data as List;
      state = data.map((json) => models.Order.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch orders");
    }
  }

  void addOrderFromCart(List<CartItem> cartItems) {
    final total = cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
    final newOrder = models.Order(
      id: state.isEmpty ? 1 : state.last.id + 1,
      items: cartItems,
      date: DateTime.now(),
      total: total,
    );
    state = [...state, newOrder];
  }
}
