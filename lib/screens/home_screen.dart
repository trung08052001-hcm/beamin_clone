import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_grid.dart';
import '../widgets/food_list_horizontal.dart';
import '../constants/colors.dart';
import '../router/app_router.gr.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Search
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => context.router.push(const AddressRoute()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Giao đến',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Trung tâm Công nghệ cao, Quận 9',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(76.0),
              child: HomeSearchBar(),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const BannerSlider(),
                const CategoryGrid(),

                // Huge Discounts Entry
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: InkWell(
                    onTap: () => context.router.push(const PromotionsRoute()),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.bolt, color: Colors.white, size: 28),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ƯU ĐÃI KHỦNG HÔM NAY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Giảm 50k, Freeship & Quà tặng 0đ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const FoodListHorizontal(title: 'Món ngon nổi bật'),
                const FoodListHorizontal(title: 'Ưu đãi hôm nay'),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
