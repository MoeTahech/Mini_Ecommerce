import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/data/product_model.dart';
import '../../home/data/product_repository.dart';

final productsProvider = StateNotifierProvider<ProductsController, List<Product>>(
  (ref) => ProductsController(),
);

class ProductsController extends StateNotifier<List<Product>> {
  ProductsController() : super([]);

  final repo = ProductRepository();

  Future<void> fetchProducts() async {
    state = await repo.fetchProducts();
  }

  void addProduct(Product product) {
    state = [...state, product];
  }

  List<Product> get lowStock =>
      state.where((product) => product.stock < 5).toList();
}
