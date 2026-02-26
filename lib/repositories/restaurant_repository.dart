import 'package:injectable/injectable.dart';

import '../models/restaurant.dart';
import '../network/api_client.dart';

@injectable
class RestaurantRepository {
  final ApiClient _apiClient;

  RestaurantRepository(this._apiClient);

  Future<List<Restaurant>> getRestaurants() {
    return _apiClient.getRestaurants();
  }

  Future<List<Restaurant>> getRestaurantsByCategory(String category) {
    return _apiClient.getRestaurantsByCategory(category);
  }

  Future<List<Restaurant>> searchRestaurants(String query) {
    return _apiClient.searchRestaurants(query);
  }
}
