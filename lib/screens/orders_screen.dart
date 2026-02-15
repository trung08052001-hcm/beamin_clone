import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

@RoutePage()
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F8),
        appBar: AppBar(
          title: const Text(
            'Đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
            tabs: const [
              Tab(text: 'Đang đến'),
              Tab(text: 'Lịch sử'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildOngoingOrders(), _buildOrderHistory()],
        ),
      ),
    );
  }

  Widget _buildOngoingOrders() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildOrderItem(
          restaurantName: 'Cơm Gà Hải Nam - Nguyễn Duy Trinh',
          status: 'Tài xế đang lấy hàng',
          items: '1x Cơm gà xối mỡ, 1x Canh rong biển',
          price: '55.000đ',
          isOngoing: true,
        ),
      ],
    );
  }

  Widget _buildOrderHistory() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildOrderItem(
          restaurantName: 'Trà Sữa Phê La - Xuân Thủy',
          status: 'Đã hoàn thành',
          items: '2x Ô Long Sữa Phê La',
          price: '110.000đ',
          date: 'Hôm nay, 10:30',
        ),
        _buildOrderItem(
          restaurantName: 'Bún Bò Huế Xưa - Lê Văn Việt',
          status: 'Đã hoàn thành',
          items: '1x Bún bò đặc biệt',
          price: '45.000đ',
          date: 'Hôm qua, 18:45',
        ),
        _buildOrderItem(
          restaurantName: 'Gà Rán Popeyes - Vincom Q9',
          status: 'Đã hủy',
          items: '1x Combo Gà Giòn',
          price: '89.000đ',
          date: '14 thg 02, 12:15',
          isCancelled: true,
        ),
      ],
    );
  }

  Widget _buildOrderItem({
    required String restaurantName,
    required String status,
    required String items,
    required String price,
    String? date,
    bool isOngoing = false,
    bool isCancelled = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  restaurantName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                status,
                style: TextStyle(
                  color: isOngoing
                      ? AppColors.primary
                      : (isCancelled ? Colors.red : Colors.grey[600]),
                  fontSize: 13,
                  fontWeight: isOngoing ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (date != null) ...[
                Text(' • ', style: TextStyle(color: Colors.grey[400])),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Text(
            items,
            style: const TextStyle(color: Color(0xFF444444), fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: isOngoing
                      ? AppColors.primary
                      : Colors.black87,
                  side: BorderSide(
                    color: isOngoing ? AppColors.primary : Colors.grey[300]!,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  minimumSize: const Size(80, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text(isOngoing ? 'Theo dõi' : 'Đặt lại'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
