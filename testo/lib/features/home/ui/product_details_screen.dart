import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/data/cart_controller.dart';
import '../data/product_model.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int quantity = 1;
  bool adding = false;

  @override
  Widget build(BuildContext context) {
    final cartCtrl = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.product.imageUrl, height: 150),
            const SizedBox(height: 16),
            Text(widget.product.description),
            const SizedBox(height: 16),
            Text("Price: \$${widget.product.price.toStringAsFixed(2)}"),
            const SizedBox(height: 8),
            Text("Stock: ${widget.product.stock}"),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  onPressed:
                      quantity > 1 ? () => setState(() => quantity--) : null,
                  icon: const Icon(Icons.remove),
                ),
                Text(quantity.toString()),
                IconButton(
                  onPressed: quantity < widget.product.stock
                      ? () => setState(() => quantity++)
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.product.stock == 0 || adding
                  ? null
                  : () async {
                      setState(() => adding = true);
                      try {
                        cartCtrl.addToCart(widget.product, quantity: quantity);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to cart")),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Failed to add to cart. Try again.")),
                        );
                      } finally {
                        setState(() => adding = false);
                      }
                    },
              child: adding
                  ? const CircularProgressIndicator()
                  : widget.product.stock == 0
                      ? const Text("Out of stock")
                      : const Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}
