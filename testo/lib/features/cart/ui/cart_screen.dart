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

    return Column(
      children: [
        Expanded(
          child: cart.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.shopping_cart, size: 60, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("Cart is empty", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, i) {
                    final item = cart[i];
                    return ListTile(
                      leading: item.product.imageUrl != null
                          ? Image.network(item.product.imageUrl!, width: 50)
                          : const Icon(Icons.image_not_supported),
                      title: Text(item.product.name),
                      subtitle: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              if (item.quantity > 1) {
                                cartCtrl.addToCart(item.product, quantity: -1);
                              } else {
                                cartCtrl.removeFromCart(item.product);
                              }
                            },
                          ),
                          Text("${item.quantity}"),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: () {
                              cartCtrl.addToCart(item.product);
                            },
                          ),
                        ],
                      ),
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
                onPressed: cart.isEmpty
                    ? null // disable if cart is empty
                    : () async {
                        try {
                          await cartCtrl.placeOrder(); // send order to backend
                          ordersCtrl.fetchUserOrders();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Order placed successfully!")),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text("Order failed: ${e.toString()}")),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                ),
                child: const Text(
                  "Place Order",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
