import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text(
          'Tài khoản',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nguyễn Văn A',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Thành viên Đồng',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Rewards Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  _buildHeaderAction(
                    Icons.confirmation_num_outlined,
                    'Mã giảm giá',
                    '5 mã',
                  ),
                  Container(width: 1, height: 40, color: Colors.grey[100]),
                  _buildHeaderAction(
                    Icons.stars_outlined,
                    'Baemin Rewards',
                    '0 xu',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Menu Options
            _buildSection([
              _buildMenuItem(Icons.location_on_outlined, 'Địa chỉ của tôi'),
              _buildMenuItem(Icons.payment_outlined, 'Ví của tôi'),
              _buildMenuItem(Icons.credit_card_outlined, 'Thanh toán'),
            ]),
            const SizedBox(height: 8),

            _buildSection([
              _buildMenuItem(Icons.favorite_border, 'Quán yêu thích'),
              _buildMenuItem(Icons.history, 'Lịch sử đánh giá'),
              _buildMenuItem(Icons.group_add_outlined, 'Mời bạn bè'),
            ]),
            const SizedBox(height: 8),

            _buildSection([
              _buildMenuItem(Icons.help_outline, 'Trung tâm trợ giúp'),
              _buildMenuItem(Icons.description_outlined, 'Chính sách bảo mật'),
              _buildMenuItem(Icons.settings_outlined, 'Cài đặt tài khoản'),
            ]),
            const SizedBox(height: 24),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Phiên bản 4.30.0',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, String title, String value) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(List<Widget> items) {
    return Container(
      color: Colors.white,
      child: Column(children: items),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.grey[700]),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
            const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
