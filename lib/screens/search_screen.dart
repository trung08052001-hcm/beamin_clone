import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/restaurant/restaurant_bloc.dart';
import '../constants/colors.dart';
import '../injection.dart';
import '../models/restaurant.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [];
  bool _isSearching = false;
  String _searchQuery = '';
  Timer? _debounceTimer;

  final List<String> _popularSearches = [
    'Bánh mì',
    'Phở',
    'Pizza',
    'Sushi',
    'Cà phê',
    'Trà trái cây',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
    });
    
    // Debounce để tránh gọi API quá nhiều
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        context.read<RestaurantBloc>().add(RestaurantSearched(query));
      }
    });
  }

  void _onSearchSubmitted(String query) {
    _debounceTimer?.cancel();
    
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
      });
    }
  }

  void _onRecentSearchTap(String query) {
    _searchController.text = query;
    _onSearchChanged(query);
    _onSearchSubmitted(query);
  }

  void _clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RestaurantBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => context.router.back(),
          ),
          titleSpacing: 0,
          title: _buildSearchField(),
        ),
        body: _isSearching ? _buildSearchResults() : _buildSearchHistory(),
      ),
    );
  }

  Widget _buildSearchField() {
    return BlocBuilder<RestaurantBloc, RestaurantState>(
      builder: (context, state) {
        return Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _onSearchChanged,
            onSubmitted: _onSearchSubmitted,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: 'Tìm món ăn, nhà hàng...',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<RestaurantBloc, RestaurantState>(
      builder: (context, state) {
        if (state is RestaurantLoading) {
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
                    if (_searchQuery.isNotEmpty) {
                      context.read<RestaurantBloc>().add(RestaurantSearched(_searchQuery));
                    }
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        } else if (state is RestaurantLoaded) {
          if (state.restaurants.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Không tìm thấy kết quả',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
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
    );
  }

  Widget _buildRestaurantItem(Restaurant restaurant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              restaurant.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
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
                    fontSize: 15,
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
                      ' (${restaurant.totalReviews})',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  restaurant.description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tìm kiếm gần đây',
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: _clearRecentSearches,
                  child: Text(
                    'Xóa tất cả',
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches
                  .map((search) => _buildSearchTag(search, isRecent: true))
                  .toList(),
            ),
            const SizedBox(height: 32),
          ],
          Text(
            'Tìm kiếm phổ biến',
            style: GoogleFonts.notoSans(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _popularSearches.length,
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.trending_up,
                  color: AppColors.primary,
                  size: 20,
                ),
                title: Text(
                  _popularSearches[index],
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  _onRecentSearchTap(_popularSearches[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTag(String text, {bool isRecent = false}) {
    return GestureDetector(
      onTap: () => _onRecentSearchTap(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isRecent ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isRecent) ...[
              Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: GoogleFonts.notoSans(fontSize: 13, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
