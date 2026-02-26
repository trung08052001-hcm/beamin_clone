part of 'restaurant_bloc.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object?> get props => [];
}

class RestaurantFetched extends RestaurantEvent {
  const RestaurantFetched();
}

class RestaurantFetchedByCategory extends RestaurantEvent {
  final String category;

  const RestaurantFetchedByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class RestaurantSearched extends RestaurantEvent {
  final String query;

  const RestaurantSearched(this.query);

  @override
  List<Object?> get props => [query];
}
