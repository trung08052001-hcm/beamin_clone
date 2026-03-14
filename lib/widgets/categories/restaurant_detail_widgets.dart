import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../constants/colors.dart';
import '../../data/brand_menus.dart';
import '../../models/product.dart';
import '../../models/restaurant.dart';
import '../../screens/cart_screen.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? align;

  const AppText(
    this.text, {
    super.key,
    this.size,
    this.weight,
    this.color,
    this.maxLines,
    this.overflow,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}

class RestaurantSliverAppBar extends StatelessWidget {
  final String imageUrl;

  const RestaurantSliverAppBar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.white,
      leading: CircleIconButton(
        icon: Icons.arrow_back,
        onPressed: () => context.router.back(),
      ),
      actions: const [
        CircleIconButton(icon: Icons.share),
        CircleIconButton(icon: Icons.favorite_border),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.restaurant, size: 64, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CircleIconButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black, size: 20),
      ),
      onPressed: onPressed ?? () {},
    );
  }
}

class RestaurantInfoSection extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantInfoSection({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              restaurant.name,
              size: 24,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, size: 18, color: Colors.amber),
                const SizedBox(width: 4),
                AppText(
                  restaurant.rating.toStringAsFixed(1),
                  size: 14,
                  weight: FontWeight.bold,
                ),
                AppText(
                  ' (${restaurant.totalReviews} đánh giá)',
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                AppText(
                  restaurant.deliveryTime,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppText(
              restaurant.description,
              size: 14,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            if (restaurant.isFreeship) const FreeshipBadge(),
          ],
        ),
      ),
    );
  }
}

class FreeshipBadge extends StatelessWidget {
  const FreeshipBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_shipping, size: 14, color: Colors.red[400]),
          const SizedBox(width: 4),
          AppText(
            'FREESHIP',
            size: 12,
            color: Colors.red[400],
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: AppText(
          'Menu',
          size: 18,
          weight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MenuList extends StatelessWidget {
  final List<BrandMenuItem> items;
  final ValueChanged<BrandMenuItem> onTapItem;

  const MenuList({super.key, required this.items, required this.onTapItem});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = items[index];
            return MenuItemCard(item: item, onTap: () => onTapItem(item));
          },
          childCount: items.length,
        ),
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final BrandMenuItem item;
  final VoidCallback onTap;

  const MenuItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          item.name,
                          size: 15,
                          weight: FontWeight.bold,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.isBestSeller) const BestSellerBadge(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    item.description,
                    size: 12,
                    color: Colors.grey,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        '${item.price.toStringAsFixed(0)}đ',
                        size: 16,
                        color: AppColors.primary,
                        weight: FontWeight.bold,
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
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

class BestSellerBadge extends StatelessWidget {
  const BestSellerBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: AppText(
        'Bán chạy',
        size: 10,
        color: Colors.orange[700],
        weight: FontWeight.bold,
      ),
    );
  }
}

class CartSummaryBar extends StatelessWidget {
  const CartSummaryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.items.isEmpty) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        AppText(
                          'Giỏ hàng (${state.totalQuantity})',
                          size: 16,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AppText(
                        '${state.totalPrice.toStringAsFixed(0)}đ',
                        size: 14,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class ProductHeaderSection extends StatelessWidget {
  final Product product;

  const ProductHeaderSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            product.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              color: Colors.grey[200],
              child: const Icon(Icons.fastfood, size: 64, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AppText(
                product.name,
                size: 22,
                weight: FontWeight.bold,
              ),
            ),
            AppText(
              '${product.price.toStringAsFixed(0)}đ',
              size: 22,
              weight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ],
        ),
        const SizedBox(height: 4),
        AppText(
          'Đã bao gồm ${product.unit}',
          size: 14,
          color: Colors.grey,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class OptionsSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final List<String> selectedKeys;
  final ValueChanged<String> onToggle;
  final String Function(num price)? priceFormatter;

  const OptionsSection({
    super.key,
    required this.title,
    required this.items,
    required this.selectedKeys,
    required this.onToggle,
    this.priceFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, size: 16, weight: FontWeight.bold),
        const SizedBox(height: 12),
        ...items.map((item) {
          final name = item['name'] as String;
          final price = item['price'] as num;
          final isSelected = selectedKeys.contains(name);
          return OptionItem(
            title: name,
            subtitle: priceFormatter?.call(price) ?? '+${price}đ',
            isSelected: isSelected,
            onTap: () => onToggle(name),
          );
        }),
        const SizedBox(height: 24),
      ],
    );
  }
}

class NoteSection extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const NoteSection({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Ghi chú',
          size: 16,
          weight: FontWeight.bold,
        ),
        const SizedBox(height: 12),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Thêm ghi chú cho cửa hàng...',
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  final int quantity;
  final double totalPrice;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onAddToCart;

  const BottomBar({
    super.key,
    required this.quantity,
    required this.totalPrice,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 20),
                    onPressed: onDecrement,
                  ),
                  SizedBox(
                    width: 30,
                    child: AppText(
                      '$quantity',
                      align: TextAlign.center,
                      size: 16,
                      weight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: onIncrement,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: onAddToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText(
                      'Thêm vào giỏ hàng',
                      size: 16,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    AppText(
                      '${totalPrice.toStringAsFixed(0)}đ',
                      size: 16,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primary : Colors.grey[400],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                title,
                size: 15,
                weight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.black87,
              ),
            ),
            AppText(
              subtitle,
              size: 14,
              color: isSelected ? AppColors.primary : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}
