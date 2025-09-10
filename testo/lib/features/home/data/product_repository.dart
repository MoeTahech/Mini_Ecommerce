import 'product_model.dart';
import '../../../core/api_client.dart';

class ProductRepository {
  final ApiClient api;

  ProductRepository(this.api);

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await api.get('/products');
      final data = response.data as List;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
}
