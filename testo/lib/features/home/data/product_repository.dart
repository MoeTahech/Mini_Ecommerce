import 'product_model.dart';
import 'package:collection/collection.dart'; // for firstWhereOrNull

class ProductRepository {
  final List<Product> _products = List.generate(
    10,
    (i) => Product(
      id: i,
      name: "Product $i",
      description: "This is the description of Product $i",
      price: 10.0 + i,
      stock: i % 3 == 0 ? 0 : 5 + i, // some out of stock
      imageUrl: "https://via.placeholder.com/150",
    ),
  );

  /// Simulate network fetch
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return _products;
  }

  /// Get product by ID (nullable)
  Product? getProductById(int id) {
    return _products.firstWhereOrNull((p) => p.id == id);
  }
}

