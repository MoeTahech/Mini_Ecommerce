import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../data/product_model.dart';
import 'product_details_screen.dart';
//port '../../../core/session.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final repo = ProductRepository();
  late Future<List<Product>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = repo.fetchProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      productsFuture = repo.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catalog")),
      body: FutureBuilder<List<Product>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Skeleton placeholders
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: 6,
              itemBuilder: (_, __) => Container(
                color: Colors.grey.shade300,
                margin: const EdgeInsets.all(4),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Failed to load products"),
                  TextButton(
                    onPressed: _refreshProducts,
                    child: const Text("Retry"),
                  ),
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
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.network(product.imageUrl,
                              height: 100, fit: BoxFit.cover),
                          const SizedBox(height: 8),
                          Text(product.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          Text("\$${product.price.toStringAsFixed(2)}"),
                        ],
                      ),
                      if (product.stock == 0)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            color: Colors.red,
                            padding: const EdgeInsets.all(4),
                            child: const Text("Out of stock",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ),
                        )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
