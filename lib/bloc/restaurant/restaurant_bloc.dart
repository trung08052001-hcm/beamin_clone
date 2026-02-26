import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../models/restaurant.dart';
import '../../repositories/restaurant_repository.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

@injectable
class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository _repository;
  List<Restaurant> _allRestaurants = [];

  RestaurantBloc(this._repository) : super(RestaurantInitial()) {
    on<RestaurantFetched>(_onRestaurantFetched);
    on<RestaurantFetchedByCategory>(_onRestaurantFetchedByCategory);
    on<RestaurantSearched>(_onRestaurantSearched);
  }

  Future<void> _onRestaurantFetched(
    RestaurantFetched event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    try {
      final restaurants = await _repository.getRestaurants();
      _allRestaurants = restaurants;
      emit(RestaurantLoaded(restaurants));
    } catch (e) {
      emit(RestaurantError('Không thể tải danh sách quán ăn. Vui lòng thử lại.'));
    }
  }

  Future<void> _onRestaurantFetchedByCategory(
    RestaurantFetchedByCategory event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    try {
      final restaurants = await _repository.getRestaurantsByCategory(event.category);
      emit(RestaurantLoaded(restaurants));
    } catch (e) {
      emit(RestaurantError('Không thể tải danh sách quán ăn. Vui lòng thử lại.'));
    }
  }

  Future<void> _onRestaurantSearched(
    RestaurantSearched event,
    Emitter<RestaurantState> emit,
  ) async {
    // Nếu đã có data trong memory, filter trực tiếp
    if (_allRestaurants.isNotEmpty) {
      final query = event.query.toLowerCase();
      final filteredRestaurants = _allRestaurants.where((restaurant) {
        return restaurant.name.toLowerCase().contains(query) ||
            restaurant.description.toLowerCase().contains(query) ||
            restaurant.category.toLowerCase().contains(query);
      }).toList();
      emit(RestaurantLoaded(filteredRestaurants));
    } else {
      // Nếu chưa có data, thử gọi API search
      try {
        final restaurants = await _repository.searchRestaurants(event.query);
        emit(RestaurantLoaded(restaurants));
      } catch (e) {
        // Nếu API thất bại, thử lấy tất cả rồi filter
        try {
          final restaurants = await _repository.getRestaurants();
          _allRestaurants = restaurants;
          final query = event.query.toLowerCase();
          final filteredRestaurants = _allRestaurants.where((restaurant) {
            return restaurant.name.toLowerCase().contains(query) ||
                restaurant.description.toLowerCase().contains(query) ||
                restaurant.category.toLowerCase().contains(query);
          }).toList();
          emit(RestaurantLoaded(filteredRestaurants));
        } catch (e2) {
          emit(RestaurantError('Không thể tìm kiếm. Vui lòng thử lại.'));
        }
      }
    }
  }
}
