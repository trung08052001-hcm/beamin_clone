import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../constants/colors.dart';
import '../../data/brand_menus.dart';
import '../../models/product.dart';
import '../../models/restaurant.dart';
import '../../widgets/categories/restaurant_detail_widgets.dart';

@RoutePage()
class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;
  final List<BrandMenuItem> menuItems;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
    this.menuItems = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          RestaurantSliverAppBar(imageUrl: restaurant.imageUrl),
          RestaurantInfoSection(restaurant: restaurant),
          const MenuHeader(),
          MenuList(
            items: menuItems,
            onTapItem: (item) => _showProductOptions(context, _toProduct(item)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomSheet: const CartSummaryBar(),
    );
  }

  Product _toProduct(BrandMenuItem item) {
    return Product(
      name: item.name,
      price: item.price,
      imageUrl: item.imageUrl,
      category: restaurant.category,
      unit: 'Phần',
    );
  }

  void _showProductOptions(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductOptionsBottomSheet(
        product: product,
        restaurantName: restaurant.name,
      ),
    );
  }
}

// Product Options Bottom Sheet (Giống Baemin)
class ProductOptionsBottomSheet extends StatefulWidget {
  final Product product;
  final String restaurantName;

  const ProductOptionsBottomSheet({
    super.key,
    required this.product,
    required this.restaurantName,
  });

  @override
  State<ProductOptionsBottomSheet> createState() =>
      _ProductOptionsBottomSheetState();
}

class _ProductOptionsBottomSheetState extends State<ProductOptionsBottomSheet> {
  int _quantity = 1;
  String? _selectedSize;
  final List<Map<String, dynamic>> _sizeOptions = [
    {'name': 'Size nhỏ', 'price': 0},
    {'name': 'Size lớn', 'price': 8000},
  ];
  final List<Map<String, dynamic>> _toppings = [
    {'name': 'Trứng chiên', 'price': 5000},
    {'name': 'Pate', 'price': 5000},
    {'name': 'Xúc xích', 'price': 7000},
    {'name': 'Phô mai', 'price': 8000},
    {'name': 'Rau mồng tơi', 'price': 3000},
  ];
  final List<String> _selectedToppings = [];
  String? _note;

  double get _totalPrice {
    double basePrice = widget.product.price;

    if (_selectedSize != null) {
      final size = _sizeOptions.firstWhere((s) => s['name'] == _selectedSize);
      basePrice += (size['price'] as num).toDouble();
    }

    for (var topping in _selectedToppings) {
      final t = _toppings.firstWhere((t) => t['name'] == topping);
      basePrice += (t['price'] as num).toDouble();
    }

    return basePrice * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              const BottomSheetHandle(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    ProductHeaderSection(product: widget.product),
                    if (_sizeOptions.isNotEmpty)
                      OptionsSection(
                        title: 'Chọn size',
                        items: _sizeOptions,
                        selectedKeys: _selectedSize == null
                            ? const []
                            : [_selectedSize!],
                        onToggle: (name) => setState(() => _selectedSize = name),
                        priceFormatter: (price) =>
                            price == 0 ? 'Mặc định' : '+${price}đ',
                      ),
                    if (_toppings.isNotEmpty)
                      OptionsSection(
                        title: 'Topping thêm',
                        items: _toppings,
                        selectedKeys: _selectedToppings,
                        onToggle: (name) {
                          setState(() {
                            if (_selectedToppings.contains(name)) {
                              _selectedToppings.remove(name);
                            } else {
                              _selectedToppings.add(name);
                            }
                          });
                        },
                      ),
                    NoteSection(onChanged: (value) => _note = value),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              BottomBar(
                quantity: _quantity,
                totalPrice: _totalPrice,
                onDecrement: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
                onIncrement: () => setState(() => _quantity++),
                onAddToCart: _handleAddToCart,
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleAddToCart() {
    double basePrice = widget.product.price;
    if (_selectedSize != null) {
      final size = _sizeOptions.firstWhere((s) => s['name'] == _selectedSize);
      basePrice += (size['price'] as num).toDouble();
    }
    for (var topping in _selectedToppings) {
      final t = _toppings.firstWhere((t) => t['name'] == topping);
      basePrice += (t['price'] as num).toDouble();
    }

    final selectedProduct = Product(
      name: widget.product.name,
      price: basePrice,
      imageUrl: widget.product.imageUrl,
      category: widget.product.category,
      unit: widget.product.unit,
    );

    context.read<CartBloc>().add(
      CartItemAdded(
        product: selectedProduct,
        restaurantName: widget.restaurantName,
        quantity: _quantity,
        note: _note,
      ),
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm $_quantity ${widget.product.name} vào giỏ hàng'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
