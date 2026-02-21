import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
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
  String? _currentAddress;
  LatLng? _currentPosition;
  bool _loadingLocation = false;
  Future<void> _getCurrentLocation() async {
    setState(() {
      _loadingLocation = true;
    });
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _loadingLocation = false;
            _currentAddress = 'Bạn cần cấp quyền vị trí cho ứng dụng.';
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _loadingLocation = false;
          _currentAddress = 'Bạn đã từ chối quyền vị trí vĩnh viễn. Vui lòng vào Cài đặt để cấp lại.';
        });
        return;
      }
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _currentPosition = LatLng(position.latitude, position.longitude);
      // Reverse geocode
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        _currentAddress = '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}';
      } else {
        _currentAddress = 'Không tìm thấy địa chỉ';
      }
    } catch (e) {
      _currentAddress = 'Lỗi định vị: $e';
    }
    setState(() {
      _loadingLocation = false;
    });
  }

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
          // Hiển thị bản đồ nhỏ nếu đã có vị trí
          if (_currentPosition != null)
            Container(
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 16,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('current'),
                      position: _currentPosition!,
                    ),
                  },
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  liteModeEnabled: true,
                ),
              ),
            ),
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
            subtitle: _loadingLocation
                ? const Text('Đang định vị...')
                : (_currentAddress != null
                    ? Text(_currentAddress!, style: const TextStyle(color: Colors.black87))
                    : const Text('Định vị vị trí hiện tại của bạn')),
            onTap: _getCurrentLocation,
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
