import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../data/product_model.dart';
import '../../../core/api_client.dart';
import 'product_details_screen.dart';

class CatalogScreen extends StatefulWidget {
  final ApiClient api;
  const CatalogScreen({super.key, required this.api});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late final ProductRepository repo;
  late Future<List<Product>> productsFuture;

  @override
  void initState() {
    super.initState();
    repo = ProductRepository(widget.api);
    productsFuture = repo.fetchProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      productsFuture = repo.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Failed to load products"),
                TextButton(onPressed: _refreshProducts, child: const Text("Retry")),
              ],
            ),
          );
        }

        final products = snapshot.data ?? [];
        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.inventory_2, size: 60, color: Colors.grey),
                SizedBox(height: 8),
                Text("No products available", style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshProducts,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
                    );
                  },
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(
                                product.imageUrl,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blue[900]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "\$${product.price.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.blue[700]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (product.stock == 0)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: const Text(
                                "Out of stock",
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
