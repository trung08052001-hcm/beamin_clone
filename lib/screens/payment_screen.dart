import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart/cart_bloc.dart';
import '../constants/colors.dart';
import 'categories/delivery_screen.dart';

@RoutePage()
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _promoController = TextEditingController();
  double _discount = 0;
  String _selectedMethod = 'cash';
  String? _promoMessage;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo(double totalPrice) {
    final code = _promoController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _discount = 0;
        _promoMessage = 'Vui lòng nhập mã giảm giá.';
      });
      return;
    }

    final discount = (totalPrice * 0.1).clamp(0, 20000).toDouble();
    setState(() {
      _discount = discount;
      _promoMessage = 'Đã áp dụng mã "$code"';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Thanh toán',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.back(),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final productPrice = state.totalPrice.toDouble();
          final orderValue =
              (productPrice - _discount).clamp(0, double.infinity).toDouble();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
            children: [
              _SectionCard(
                title: 'Mã giảm giá',
                child: Column(
                  children: [
                    TextField(
                      controller: _promoController,
                      decoration: InputDecoration(
                        hintText: 'Nhập mã giảm giá',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _applyPromo(productPrice),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Áp dụng'),
                      ),
                    ),
                    if (_promoMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _promoMessage!,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              _SectionCard(
                title: 'Phương thức thanh toán',
                child: Column(
                  children: [
                    _PaymentOption(
                      value: 'cash',
                      groupValue: _selectedMethod,
                      title: 'Tiền mặt',
                      subtitle: 'Thanh toán khi nhận hàng',
                      onChanged: (value) => setState(() => _selectedMethod = value),
                    ),
                    _PaymentOption(
                      value: 'momo',
                      groupValue: _selectedMethod,
                      title: 'Ví MoMo',
                      subtitle: 'Thanh toán nhanh qua MoMo',
                      onChanged: (value) => setState(() => _selectedMethod = value),
                    ),
                    _PaymentOption(
                      value: 'zalopay',
                      groupValue: _selectedMethod,
                      title: 'ZaloPay',
                      subtitle: 'Thanh toán qua ZaloPay',
                      onChanged: (value) => setState(() => _selectedMethod = value),
                    ),
                  ],
                ),
              ),
              _SectionCard(
                title: 'Tóm tắt đơn hàng',
                child: Column(
                  children: [
                    _SummaryRow(label: 'Giá sản phẩm', value: productPrice),
                    _SummaryRow(label: 'Giảm giá', value: -_discount),
                    const Divider(height: 20),
                    _SummaryRow(
                      label: 'Giá trị đơn hàng',
                      value: orderValue,
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomSheet: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) return const SizedBox.shrink();
          final total = (state.totalPrice.toDouble() - _discount)
              .clamp(0, double.infinity)
              .toDouble();
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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DeliveryScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Thanh toán ${total.toStringAsFixed(0)}đ',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final String title;
  final String subtitle;
  final ValueChanged<String> onChanged;

  const _PaymentOption({
    required this.value,
    required this.groupValue,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      onChanged: (v) => onChanged(v!),
      activeColor: AppColors.primary,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      fontSize: isTotal ? 16 : 14,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text('${value.toStringAsFixed(0)}đ', style: textStyle),
        ],
      ),
    );
  }
}
