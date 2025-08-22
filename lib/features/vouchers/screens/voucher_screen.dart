import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/voucher_provider.dart';
import '../widgets/voucher_card.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VoucherProvider>(context, listen: false).fetchVouchers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final voucherProvider = Provider.of<VoucherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Danh Sách Voucher')),
      body:
          voucherProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : voucherProvider.errorMessage != null
              ? Center(child: Text(voucherProvider.errorMessage!))
              : ListView.builder(
                itemCount: voucherProvider.vouchers.length,
                itemBuilder: (context, index) {
                  return VoucherCard(voucher: voucherProvider.vouchers[index]);
                },
              ),
    );
  }
}
