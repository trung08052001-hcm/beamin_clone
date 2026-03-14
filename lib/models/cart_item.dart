import 'package:equatable/equatable.dart';

import 'product.dart';

class CartItem extends Equatable {
  final Product product;
  final String restaurantName;
  final int quantity;
  final String? note;

  const CartItem({
    required this.product,
    required this.restaurantName,
    required this.quantity,
    this.note,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    String? restaurantName,
    int? quantity,
    String? note,
  }) {
    return CartItem(
      product: product ?? this.product,
      restaurantName: restaurantName ?? this.restaurantName,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [product, restaurantName, quantity, note];
}
