import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/data/cart_item.dart';
import '../../home/data/product_model.dart';
import '../../../core/api_client.dart';
import '../../../core/session.dart';

// Provider for ApiClient (replace with your backend URL)
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient("http://localhost:8080"); // adjust baseUrl
});

final cartProvider =
    StateNotifierProvider<CartController, List<CartItem>>(
        (ref) => CartController(ref));

class CartController extends StateNotifier<List<CartItem>> {
  final Ref ref;
  CartController(this.ref) : super([]);

  void addToCart(Product product, {int quantity = 1}) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final item = state[index];
      final newQuantity = item.quantity + quantity;
      if (newQuantity <= product.stock) {
        state[index] = CartItem(product: item.product, quantity: newQuantity);
        state = [...state];
      }
    } else {
      if (quantity <= product.stock) {
        state = [...state, CartItem(product: product, quantity: quantity)];
      }
    }
  }

  void removeFromCart(Product product) {
    state = state.where((item) => item.product.id != product.id).toList();
  }

  void clearCart() => state = [];

  double get subtotal => state.fold(0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * 0.1;
  double get total => subtotal + tax;

  /// Place order safely
  Future<void> placeOrder() async {
    if (state.isEmpty) throw Exception("Cart is empty");

    final token = await Session.getToken();
    if (token == null) throw Exception("User not logged in");

    final api = ref.read(apiClientProvider);
    api.setToken(token);

    final itemsPayload = state
        .map((item) => {"productId": item.product.id, "quantity": item.quantity})
        .toList();

    print("Placing order: $itemsPayload");

    try {
      final response = await api.post('/orders', {"items": itemsPayload});

      print("Response: ${response.statusCode} ${response.data}");

      if (response.statusCode == 201) {
        clearCart();
      } else {
        throw Exception(
            "Failed to place order: ${response.data ?? 'No response data'}");
      }
    } catch (e) {
      throw Exception("Order request failed: $e");
    }
  }
}
