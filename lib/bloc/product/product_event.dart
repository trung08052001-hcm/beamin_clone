part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class ProductFetched extends ProductEvent {
  const ProductFetched();
}

class ProductFetchedByCategory extends ProductEvent {
  final String category;

  const ProductFetchedByCategory(this.category);

  @override
  List<Object?> get props => [category];
}
