import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../data/product_model.dart';
import 'product_details_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catalog")),
      body: FutureBuilder<List<Product>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products available"));
          }

          final products = snapshot.data!;
          return GridView.builder(
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
                        Image.network(product.imageUrl, height: 100, fit: BoxFit.cover),
                        const SizedBox(height: 8),
                        Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          child: const Text("Out of stock", style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
