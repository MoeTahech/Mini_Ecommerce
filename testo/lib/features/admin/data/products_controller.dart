import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/data/product_model.dart';
import '../../home/data/product_repository.dart';
import '../../../core/api_client.dart';
import '../../../core/session.dart';

// 1️⃣ Provider for ProductsController
final productsProvider =
    StateNotifierProvider<ProductsController, List<Product>>(
  (ref) {
    final api = ApiClient("http://localhost:8080");
    // Set token if user is logged in
    Session.getToken().then((token) {
      if (token != null) api.setToken(token);
    });
    return ProductsController(api);
  },
);

// 2️⃣ ProductsController class
class ProductsController extends StateNotifier<List<Product>> {
  final ProductRepository repo;

  ProductsController(ApiClient api)
      : repo = ProductRepository(api),
        super([]) {
    fetchProducts(); // Automatically fetch products on creation
  }

  // Fetch products from backend
  Future<void> fetchProducts() async {
    try {
      final products = await repo.fetchProducts();
      state = products;
    } catch (e) {
      // You can also handle errors here or rethrow
      print('Error fetching products: $e');
      state = [];
    }
  }

  // Add a product locally (for admin adding)
  void addProduct(Product product) {
    state = [...state, product];
  }

  // Low stock filter
  List<Product> get lowStock =>
      state.where((product) => product.stock < 5).toList();
}
