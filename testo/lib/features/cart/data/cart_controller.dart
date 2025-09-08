import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/data/cart_item.dart';
import '../../home/data/product_model.dart';

final cartProvider =
    StateNotifierProvider<CartController, List<CartItem>>(
        (ref) => CartController());

class CartController extends StateNotifier<List<CartItem>> {
  CartController() : super([]);

  void addToCart(Product product, {int quantity = 1}) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final item = state[index];
      final newQuantity = item.quantity + quantity;
      if (newQuantity <= product.stock) {
        state[index] = CartItem(product: item.product, quantity: newQuantity);
        state = [...state];
      } else {
        // Optional: show toast/snackbar from UI about stock limit
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

  /// New method to safely place order, handling stock race conditions
  Future<void> placeOrder(Future<void> Function(int productId, int quantity) reduceStockFunc) async {
    // Check stock for all items
    for (final item in state) {
      if (item.quantity > item.product.stock) {
        throw Exception("Stock changed for ${item.product.name}");
      }
    }

    // Reduce stock (simulate server update)
    for (final item in state) {
      await reduceStockFunc(item.product.id, item.quantity);
    }

    // Clear cart
    clearCart();
  }
}
