import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/cart_controller.dart';
import '../../orders/orders_controller.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartCtrl = ref.read(cartProvider.notifier);
    final ordersCtrl = ref.read(ordersProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: cart.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, i) {
                      final item = cart[i];
                      return ListTile(
                        title: Text(item.product.name),
                        subtitle: Text("x${item.quantity}"),
                        trailing: Text(
                          "\$${item.totalPrice.toStringAsFixed(2)}",
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Subtotal: \$${cartCtrl.subtotal.toStringAsFixed(2)}",
                      ),
                      Text("Tax: \$${cartCtrl.tax.toStringAsFixed(2)}"),
                      Text("Total: \$${cartCtrl.total.toStringAsFixed(2)}"),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Check for stock issues
                          if (cart.any(
                            (item) => item.quantity > item.product.stock,
                          )) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Stock error!")),
                            );
                            return;
                          }

                          // Add order to OrdersProvider
                          ordersCtrl.addOrder(cart, cartCtrl.total);

                          // Clear cart
                          cartCtrl.clearCart();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Order placed!")),
                          );
                        },
                        child: const Text("Place Order"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
