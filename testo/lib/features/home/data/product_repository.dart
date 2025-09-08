import 'product_model.dart';
import 'dart:math';

class ProductRepository {
  final _random = Random();

  List<Product> _mockProducts = [
    Product(
        id: 1,
        name: "Laptop",
        description: "High performance laptop",
        price: 1500,
        stock: 3,
        imageUrl: "https://via.placeholder.com/150"),
    Product(
        id: 2,
        name: "Headphones",
        description: "Noise cancelling headphones",
        price: 200,
        stock: 0,
        imageUrl: "https://via.placeholder.com/150"),
    Product(
        id: 3,
        name: "Smartphone",
        description: "Latest smartphone model",
        price: 999,
        stock: 5,
        imageUrl: "https://via.placeholder.com/150"),
  ];

  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 1));

    // Random network failure 20% of the time
    if (_random.nextInt(10) < 2) throw Exception("Failed to load products");

    return _mockProducts;
  }

  // Simulate race condition: stock may change randomly
  Future<void> reduceStock(int productId, int quantity) async {
    final index = _mockProducts.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      final currentStock = _mockProducts[index].stock;
      final reduceBy = min(quantity, currentStock); // prevent negative
      _mockProducts[index] =
          _mockProducts[index].copyWith(stock: currentStock - reduceBy);
    }
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
