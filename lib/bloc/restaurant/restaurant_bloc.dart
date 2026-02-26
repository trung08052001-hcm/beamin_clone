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

  RestaurantBloc(this._repository) : super(RestaurantInitial()) {
    on<RestaurantFetched>(_onRestaurantFetched);
    on<RestaurantFetchedByCategory>(_onRestaurantFetchedByCategory);
  }

  Future<void> _onRestaurantFetched(
    RestaurantFetched event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    try {
      final restaurants = await _repository.getRestaurants();
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
}
