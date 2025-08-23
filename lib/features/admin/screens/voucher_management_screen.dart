import 'package:flutter/material.dart';
import 'package:hotel_booking_frontend/features/admin/dto/voucher/voucher_create_dto.dart';
import 'package:hotel_booking_frontend/features/vouchers/models/voucher.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';

class VoucherManagementScreen extends StatefulWidget {
  const VoucherManagementScreen({super.key});

  @override
  _VoucherManagementScreenState createState() =>
      _VoucherManagementScreenState();
}

class _VoucherManagementScreenState extends State<VoucherManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchVouchers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Quản Lý Voucher')),
      body:
          adminProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : adminProvider.errorMessage != null
              ? Center(child: Text(adminProvider.errorMessage!))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: adminProvider.vouchers.length,
                      itemBuilder: (context, index) {
                        final voucher = adminProvider.vouchers[index];
                        return ListTile(
                          title: Text('Mã: ${voucher.code}'),
                          subtitle: Text(
                            'Giảm: ${voucher.discount}%, Hết hạn: ${voucher.expiryDate.toLocal()}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed:
                                    () => _showEditVoucherDialog(
                                      context,
                                      adminProvider,
                                      voucher,
                                    ),
                              ),
                              Switch(
                                value: voucher.isActive,
                                onChanged: (value) {
                                  final updatedDto = VoucherCreateDto(
                                    code: voucher.code,
                                    discount: voucher.discount,
                                    expiryDate: voucher.expiryDate,
                                    isActive: value,
                                  );
                                  adminProvider.updateVoucher(
                                    voucher.id,
                                    updatedDto,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text('Xác nhận xóa'),
                                          content: const Text(
                                            'Bạn có chắc muốn xóa voucher này?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: const Text('Hủy'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                adminProvider.deleteVoucher(
                                                  voucher.id,
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Xóa'),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed:
                          () => _showAddVoucherDialog(context, adminProvider),
                      child: const Text('Thêm Voucher'),
                    ),
                  ),
                ],
              ),
    );
  }

  void _showAddVoucherDialog(BuildContext context, AdminProvider provider) {
    final _codeController = TextEditingController();
    final _discountController = TextEditingController();
    final _expiryController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm Voucher Mới'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: 'Mã Voucher'),
                ),
                TextField(
                  controller: _discountController,
                  decoration: const InputDecoration(labelText: 'Giảm (%)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _expiryController,
                  decoration: const InputDecoration(
                    labelText: 'Ngày hết hạn (yyyy-MM-dd)',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final dto = VoucherCreateDto(
                    code: _codeController.text,
                    discount: int.parse(_discountController.text),
                    expiryDate: DateTime.parse(_expiryController.text),
                  );
                  provider.createVoucher(dto);
                  Navigator.pop(context);
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  void _showEditVoucherDialog(
    BuildContext context,
    AdminProvider provider,
    Voucher voucher,
  ) {
    final _codeController = TextEditingController(text: voucher.code);
    final _discountController = TextEditingController(
      text: voucher.discount.toString(),
    );
    final _expiryController = TextEditingController(
      text: voucher.expiryDate.toIso8601String().split('T')[0],
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Chỉnh Sửa Voucher'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: 'Mã Voucher'),
                ),
                TextField(
                  controller: _discountController,
                  decoration: const InputDecoration(labelText: 'Giảm (%)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _expiryController,
                  decoration: const InputDecoration(
                    labelText: 'Ngày hết hạn (yyyy-MM-dd)',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final dto = VoucherCreateDto(
                    code: _codeController.text,
                    discount: int.parse(_discountController.text),
                    expiryDate: DateTime.parse(_expiryController.text),
                    isActive: voucher.isActive, // Giữ trạng thái hiện tại
                  );
                  provider.updateVoucher(voucher.id, dto);
                  Navigator.pop(context);
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
    );
  }
}
