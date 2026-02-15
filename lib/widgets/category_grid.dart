import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../router/app_router.gr.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'icon': Icons.restaurant_rounded, 'label': 'Đồ ăn', 'route': FoodRoute()},
    {
      'icon': Icons.shopping_basket_rounded,
      'label': 'Mart',
      'route': MartRoute(),
    },
    {
      'icon': Icons.local_shipping_rounded,
      'label': 'Giao hàng',
      'route': DeliveryRoute(),
    },
    {'icon': Icons.storefront_rounded, 'label': 'Chợ', 'route': MarketRoute()},
    {
      'icon': Icons.card_giftcard_rounded,
      'label': 'Quà tặng',
      'route': GiftRoute(),
    },
    {
      'icon': Icons.wine_bar_rounded,
      'label': 'Tiệc tùng',
      'route': PartyRoute(),
    },
    {'icon': Icons.coffee_rounded, 'label': 'Cà phê', 'route': CoffeeRoute()},
    {'icon': Icons.more_horiz_rounded, 'label': 'Thêm', 'route': null},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return InkWell(
            onTap: () {
              if (category['route'] != null) {
                context.router.push(category['route'] as PageRouteInfo);
              }
            },
            child: Column(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      category['icon'] as IconData,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category['label'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF444444),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
