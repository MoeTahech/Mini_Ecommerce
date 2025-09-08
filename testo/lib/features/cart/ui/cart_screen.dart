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

    if (cart.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shopping_cart, size: 60, color: Colors.grey),
            SizedBox(height: 8),
            Text("Cart is empty", style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, i) {
              final item = cart[i];
              return ListTile(
                title: Text(item.product.name),
                subtitle: Text("x${item.quantity}"),
                trailing: Text("\$${item.totalPrice.toStringAsFixed(2)}"),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Subtotal: \$${cartCtrl.subtotal.toStringAsFixed(2)}"),
              Text("Tax: \$${cartCtrl.tax.toStringAsFixed(2)}"),
              Text("Total: \$${cartCtrl.total.toStringAsFixed(2)}"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // Disable if any item exceeds stock
                  if (cart.any((item) => item.quantity > item.product.stock)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Some items exceed stock!")),
                    );
                    return;
                  }

                  try {
                    // Place order using CartController method
                    await cartCtrl.placeOrder((productId, qty) async {
                      // Simulate server stock deduction
                      final product =
                          cart.firstWhere((item) => item.product.id == productId).product;
                      if (qty > product.stock) {
                        throw Exception("Stock insufficient for ${product.name}");
                      }
                      // In real app, update stock on server here
                    });

                    // Add order to OrdersController
                    ordersCtrl.addOrder(cart, cartCtrl.total);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Order placed!")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Order failed: ${e.toString()}")),
                    );
                  }
                },
                child: const Text("Place Order"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
