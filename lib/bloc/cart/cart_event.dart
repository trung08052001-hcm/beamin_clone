part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartItemAdded extends CartEvent {
  final Product product;
  final String restaurantName;
  final int quantity;
  final String? note;

  const CartItemAdded({
    required this.product,
    required this.restaurantName,
    this.quantity = 1,
    this.note,
  });

  @override
  List<Object?> get props => [product, restaurantName, quantity, note];
}

class CartItemRemoved extends CartEvent {
  final CartItem item;

  const CartItemRemoved(this.item);

  @override
  List<Object?> get props => [item];
}

class CartItemQuantityUpdated extends CartEvent {
  final CartItem item;
  final int quantity;

  const CartItemQuantityUpdated({
    required this.item,
    required this.quantity,
  });

  @override
  List<Object?> get props => [item, quantity];
}

class CartCleared extends CartEvent {
  const CartCleared();
}
