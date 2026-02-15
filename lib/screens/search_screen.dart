import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/common/app_search_field.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [
    'Cơm tấm',
    'Trà sữa',
    'Bún đậu mắm tôm',
    'Gà rán',
  ];

  final List<String> _popularSearches = [
    'Bánh mì',
    'Phở',
    'Pizza',
    'Sushi',
    'Cà phê',
    'Trà trái cây',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: AppSearchField(
          controller: _searchController,
          hintText: 'Tìm món ăn, nhà hàng...',
          autofocus: true,
          height: 40,
          onSubmitted: (value) {
            // Handle search
          },
        ),
      ),
      body: SingleChildScrollView(
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
                    onTap: () {
                      setState(() {
                        _recentSearches.clear();
                      });
                    },
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
                    .map((search) => _buildSearchTag(search))
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
                    _searchController.text = _popularSearches[index];
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: GoogleFonts.notoSans(fontSize: 13, color: Colors.grey.shade700),
      ),
    );
  }
}
