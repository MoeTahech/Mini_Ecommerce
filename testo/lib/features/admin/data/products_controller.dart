import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api_client.dart';
import '../../../core/session.dart';
import '../../home/data/product_model.dart';

// ApiClient provider (backend)
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient("http://localhost:8080"); // adjust baseUrl
});

final productsProvider =
    StateNotifierProvider<ProductsController, List<Product>>(
        (ref) => ProductsController(ref));

class ProductsController extends StateNotifier<List<Product>> {
  final Ref ref;
  List<Product> lowStock = [];
  ProductsController(this.ref) : super([]);

  // Fetch products from backend
  Future<void> fetchProducts() async {
    final token = await Session.getToken();
    final api = ref.read(apiClientProvider);
    if (token != null) api.setToken(token);

    final response = await api.get('/products');
    if (response.statusCode == 200) {
      final data = response.data as List;
      state = data.map((json) => Product.fromJson(json)).toList();

      // Update low-stock list
      lowStock = state.where((p) => p.stock <= 5).toList();
    }
  }

  // Add product (POST /products)
  Future<void> addProduct(Product product) async {
    final token = await Session.getToken();
    if (token == null) throw Exception("Admin not logged in");

    final api = ref.read(apiClientProvider);
    api.setToken(token);

    final response = await api.post('/products', product.toJson());
    if (response.statusCode == 201) {
      state = [...state, Product.fromJson(response.data)];
      // Update low-stock
      lowStock = state.where((p) => p.stock <= 5).toList();
    } else {
      throw Exception("Failed to add product");
    }
  }
}
