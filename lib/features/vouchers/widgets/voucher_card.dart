import 'package:flutter/material.dart';
import '../models/voucher.dart';

class VoucherCard extends StatelessWidget {
  final Voucher voucher;

  const VoucherCard({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Mã: ${voucher.code}'),
        subtitle: Text(
          'Giảm: ${voucher.discount}% - Hết hạn: ${voucher.expiryDate.toLocal()}',
        ),
        trailing:
            voucher.isActive
                ? const Icon(Icons.check, color: Colors.green)
                : const Icon(Icons.close, color: Colors.red),
      ),
    );
  }
}
