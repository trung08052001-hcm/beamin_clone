import 'package:injectable/injectable.dart';

import '../models/product.dart';
import '../network/api_client.dart';

@injectable
class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  Future<List<Product>> getProducts() {
    return _apiClient.getProducts();
  }

  Future<List<Product>> getProductsByCategory(String category) {
    return _apiClient.getProductsByCategory(category);
  }
}
