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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor:Colors.blue[700],
        foregroundColor: Colors.black, // product name color
        centerTitle: false, // align title to the start (left)
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width * 0.65,
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // align to top-left
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  widget.product.imageUrl,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.product.description,
                style: TextStyle(color: Colors.blue[900]),
              ),
              const SizedBox(height: 16),
              Text(
                "Price: \$${widget.product.price.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.blue[700]),
              ),
              const SizedBox(height: 8),
              Text(
                "Stock: ${widget.product.stock}",
                style: TextStyle(color: Colors.blue[900]),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    onPressed: quantity > 1
                        ? () => setState(() => quantity--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    quantity.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  IconButton(
                    onPressed: quantity < widget.product.stock
                        ? () => setState(() => quantity++)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: widget.product.stock == 0 || adding
                      ? null
                      : () async {
                          setState(() => adding = true);
                          try {
                            cartCtrl.addToCart(
                              widget.product,
                              quantity: quantity,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Added to cart")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Failed to add to cart. Try again.",
                                ),
                              ),
                            );
                          } finally {
                            setState(() => adding = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: adding
                      ? const CircularProgressIndicator(color: Colors.white)
                      : widget.product.stock == 0
                      ? const Text("Out of stock")
                      : const Text(
                          "Add to Cart",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
