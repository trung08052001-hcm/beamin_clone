import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/restaurant/restaurant_bloc.dart';
import '../../constants/colors.dart';
import '../../injection.dart';
import '../../models/restaurant.dart';

@RoutePage()
class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RestaurantBloc>()..add(const RestaurantFetched()),
      child: const _FoodScreenBody(),
    );
  }
}

class _FoodScreenBody extends StatefulWidget {
  const _FoodScreenBody();

  @override
  State<_FoodScreenBody> createState() => _FoodScreenBodyState();
}

class _FoodScreenBodyState extends State<_FoodScreenBody> {
  String _selectedCategory = 'Tất cả';

  // Map filter label với category trong database
  final Map<String, List<String>> _categoryFilters = {
    'Tất cả': [],
    'Cơm': ['Cơm'],
    'Bún/Phở': ['Bún/Phở'],
    'Trà sữa': ['Trà sữa', 'Ăn vặt'], // Trà sữa nằm trong Ăn vặt
    'Ăn vặt': ['Ăn vặt'],
    'Gà rán': ['Gà rán'],
  };

  void _onFilterSelected(String label) {
    setState(() {
      _selectedCategory = label;
    });
  }

  List<Restaurant> _filterRestaurants(List<Restaurant> restaurants) {
    final categories = _categoryFilters[_selectedCategory] ?? [];
    
    // Nếu chọn "Tất cả" thì hiện tất cả
    if (categories.isEmpty) {
      return restaurants;
    }
    
    // Lọc theo category
    return restaurants.where((r) => categories.contains(r.category)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Đồ ăn',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter / Subcategory row
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('Tất cả', isSelected: _selectedCategory == 'Tất cả'),
                _buildFilterChip('Cơm', isSelected: _selectedCategory == 'Cơm'),
                _buildFilterChip('Bún/Phở', isSelected: _selectedCategory == 'Bún/Phở'),
                _buildFilterChip('Trà sữa', isSelected: _selectedCategory == 'Trà sữa'),
                _buildFilterChip('Ăn vặt', isSelected: _selectedCategory == 'Ăn vặt'),
                _buildFilterChip('Gà rán', isSelected: _selectedCategory == 'Gà rán'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<RestaurantBloc, RestaurantState>(
              builder: (context, state) {
                if (state is RestaurantInitial) {
                  context.read<RestaurantBloc>().add(const RestaurantFetched());
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RestaurantLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RestaurantError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<RestaurantBloc>().add(const RestaurantFetched());
                          },
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                } else if (state is RestaurantLoaded) {
                  final filteredRestaurants = _filterRestaurants(state.restaurants);
                  if (filteredRestaurants.isEmpty) {
                    return const Center(
                      child: Text('Chưa có quán ăn nào.'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = filteredRestaurants[index];
                      return _buildRestaurantItem(restaurant);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => _onFilterSelected(label),
        child: Chip(
          label: Text(label),
          backgroundColor: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.grey[100],
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildRestaurantItem(Restaurant restaurant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              restaurant.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.restaurant, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(
                      ' ${restaurant.rating.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      ' (${restaurant.totalReviews}) • ${restaurant.deliveryTime}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  restaurant.description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (restaurant.isFreeship)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      'FREESHIP',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
