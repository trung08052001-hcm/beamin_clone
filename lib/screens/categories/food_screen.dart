import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../data/brand_menus.dart';
import '../../models/restaurant.dart';
import '../cart_screen.dart';
import 'restaurant_detail_screen.dart';

@RoutePage()
class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FoodScreenBody();
  }
}

class _FoodScreenBody extends StatefulWidget {
  const _FoodScreenBody();

  @override
  State<_FoodScreenBody> createState() => _FoodScreenBodyState();
}

class _FoodScreenBodyState extends State<_FoodScreenBody> {
  List<Restaurant> _buildRestaurants() {
    final restaurants = <Restaurant>[];
    for (final entry in brandMenus.entries) {
      final items = entry.value;
      final imageUrl = items.isNotEmpty ? items.first.imageUrl : '';
      restaurants.add(
        Restaurant(
          name: entry.key,
          imageUrl: imageUrl,
          rating: 4.5,
          totalReviews: '120',
          deliveryTime: '20-30 phút',
          description: 'Món ngon mỗi ngày',
          isFreeship: true,
          category: 'Khác',
        ),
      );
    }
    return restaurants;
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                final restaurants = _buildRestaurants();
                if (restaurants.isEmpty) {
                  return const Center(
                    child: Text('Chưa có quán ăn nào.'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    return _buildRestaurantItem(restaurant);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantItem(Restaurant restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailScreen(
              restaurant: restaurant,
              menuItems: brandMenus[restaurant.name] ?? const [],
            ),
          ),
        );
      },
      child: Container(
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
      ),
    );
  }
}
