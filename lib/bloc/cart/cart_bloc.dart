import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/cart_item.dart';
import '../../models/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemQuantityUpdated>(_onQuantityUpdated);
    on<CartCleared>(_onCleared);
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere(
      (item) =>
          item.product.name == event.product.name &&
          item.restaurantName == event.restaurantName,
    );

    if (index >= 0) {
      final existing = items[index];
      final mergedNote = existing.note ?? event.note;
      items[index] = existing.copyWith(
        quantity: existing.quantity + event.quantity,
        note: mergedNote,
      );
    } else {
      items.add(
        CartItem(
          product: event.product,
          restaurantName: event.restaurantName,
          quantity: event.quantity,
          note: event.note,
        ),
      );
    }

    emit(state.copyWith(items: items));
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items)..remove(event.item);
    emit(state.copyWith(items: items));
  }

  void _onQuantityUpdated(CartItemQuantityUpdated event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexOf(event.item);
    if (index < 0) return;

    if (event.quantity <= 0) {
      items.removeAt(index);
    } else {
      items[index] = event.item.copyWith(quantity: event.quantity);
    }
    emit(state.copyWith(items: items));
  }

  void _onCleared(CartCleared event, Emitter<CartState> emit) {
    emit(const CartState(items: []));
  }
}
