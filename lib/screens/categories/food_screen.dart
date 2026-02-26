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

class _FoodScreenBody extends StatelessWidget {
  const _FoodScreenBody();

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
                _buildFilterChip('Tất cả', isSelected: true),
                _buildFilterChip('Cơm'),
                _buildFilterChip('Bún/Phở'),
                _buildFilterChip('Trà sữa'),
                _buildFilterChip('Ăn vặt'),
                _buildFilterChip('Gà rán'),
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
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is RestaurantLoaded) {
                  if (state.restaurants.isEmpty) {
                    return const Center(
                      child: Text('Chưa có quán ăn nào.'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = state.restaurants[index];
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
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : Colors.grey[100],
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
