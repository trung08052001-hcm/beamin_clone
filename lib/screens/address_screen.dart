import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';
import '../../router/app_router.gr.dart';
import '../widgets/common/app_search_field.dart';

@RoutePage()
class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.router.back(),
        ),
        title: Text(
          'Địa chỉ giao hàng',
          style: GoogleFonts.notoSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppSearchField(
              controller: _addressController,
              hintText: 'Tìm địa chỉ, tòa nhà...',
            ),
          ),

          // Current Location Button
          ListTile(
            leading: const Icon(Icons.my_location, color: AppColors.primary),
            title: Text(
              'Sử dụng vị trí hiện tại',
              style: GoogleFonts.notoSans(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            subtitle: const Text('Định vị vị trí hiện tại của bạn'),
            onTap: () {
              // Handle current location
            },
          ),
          const Divider(thickness: 1, height: 1),

          // Saved/Recent Locations Label
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            color: Colors.grey.shade50,
            child: Text(
              'ĐỊA CHỈ GẦN ĐÂY',
              style: GoogleFonts.notoSans(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Recent Locations List
          Expanded(
            child: ListView.separated(
              itemCount: 3,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final locations = [
                  {
                    'title': 'Trung tâm Công nghệ cao',
                    'address': 'Quận 9, TP. Thủ Đức, TP. Hồ Chí Minh',
                  },
                  {
                    'title': 'Chung cư Vinhomes Central Park',
                    'address': '720A Điện Biên Phủ, Quận Bình Thạnh',
                  },
                  {
                    'title': 'Đại học Bách Khoa',
                    'address': '268 Lý Thường Kiệt, Quận 10',
                  },
                ];

                return ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: Colors.grey,
                    size: 20,
                  ),
                  title: Text(
                    locations[index]['title']!,
                    style: GoogleFonts.notoSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    locations[index]['address']!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    context.router.back();
                  },
                );
              },
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.router.push(const MapSelectionRoute());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Chọn trên bản đồ',
                  style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
