import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../models/product.dart';
import '../../repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;
  List<Product> _allProducts = [];

  ProductBloc(this._repository) : super(ProductInitial()) {
    on<ProductFetched>(_onProductFetched);
    on<ProductFetchedByCategory>(_onProductFetchedByCategory);
  }

  Future<void> _onProductFetched(
    ProductFetched event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _repository.getProducts();
      _allProducts = products;
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Không thể tải danh sách sản phẩm. Vui lòng thử lại.'));
    }
  }

  Future<void> _onProductFetchedByCategory(
    ProductFetchedByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _repository.getProductsByCategory(event.category);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Không thể tải sản phẩm theo danh mục. Vui lòng thử lại.'));
    }
  }
}
