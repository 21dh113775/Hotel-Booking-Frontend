import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../rooms/models/room.dart';
import '../providers/booking_provider.dart';
import '../models/booking.dart';
import 'booking_success_screen.dart';
import '../../../features/auth/providers/auth_provider.dart';
// === GIẢI THÍCH: Import VoucherProvider để sử dụng apply voucher ===
// Lý do: Tích hợp module voucher vào form đặt phòng để áp dụng giảm giá ===
import '../../../features/vouchers/providers/voucher_provider.dart';

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});

  @override
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _checkInController = TextEditingController();
  final _checkOutController = TextEditingController();
  int? _comboId;
  List<int> _drinkIds = [];
  // === GIẢI THÍCH: Thêm biến lưu mã voucher ===
  // Lý do: Cho phép người dùng nhập mã để áp dụng giảm giá trước khi đặt phòng ===
  String _voucherCode = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).initialize(context);
    });
  }

  @override
  void dispose() {
    _checkInController.dispose();
    _checkOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Room room = ModalRoute.of(context)!.settings.arguments as Room;
    final bookingProvider = Provider.of<BookingProvider>(context);
    // === GIẢI THÍCH: Lấy VoucherProvider để apply voucher ===
    // Lý do: Sử dụng provider riêng để quản lý trạng thái voucher, tránh lẫn với booking ===
    final voucherProvider = Provider.of<VoucherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Đặt Phòng ${room.roomNumber}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _checkInController,
              decoration: const InputDecoration(
                labelText: 'Check-in (dd/MM/yyyy)',
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  _checkInController.text = DateFormat(
                    'dd/MM/yyyy',
                  ).format(date);
                }
              },
            ),
            TextField(
              controller: _checkOutController,
              decoration: const InputDecoration(
                labelText: 'Check-out (dd/MM/yyyy)',
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  _checkOutController.text = DateFormat(
                    'dd/MM/yyyy',
                  ).format(date);
                }
              },
            ),
            DropdownButton<int?>(
              hint: const Text('Chọn Combo'),
              value: _comboId,
              items: const [
                DropdownMenuItem(value: null, child: Text('Không chọn')),
                DropdownMenuItem(
                  value: 1,
                  child: Text('Combo Phòng + Nội Thất'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Combo Phòng + Bữa Sáng'),
                ),
              ],
              onChanged: (value) => setState(() => _comboId = value),
            ),
            const Text('Chọn Đồ Uống:'),
            CheckboxListTile(
              title: const Text('Nước suối'),
              value: _drinkIds.contains(1),
              onChanged:
                  (value) => setState(() {
                    if (value == true) {
                      _drinkIds.add(1);
                    } else {
                      _drinkIds.remove(1);
                    }
                  }),
            ),
            CheckboxListTile(
              title: const Text('Cà phê lon'),
              value: _drinkIds.contains(2),
              onChanged:
                  (value) => setState(() {
                    if (value == true) {
                      _drinkIds.add(2);
                    } else {
                      _drinkIds.remove(2);
                    }
                  }),
            ),
            // === GIẢI THÍCH: Thêm trường nhập mã voucher ===
            // Lý do: Cho phép người dùng nhập mã để apply giảm giá, tích hợp với backend ===
            TextField(
              onChanged: (value) => _voucherCode = value,
              decoration: const InputDecoration(
                labelText: 'Mã Voucher (nếu có)',
              ),
            ),
            const SizedBox(height: 16),
            bookingProvider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () async {
                    try {
                      final checkIn = DateFormat(
                        'dd/MM/yyyy',
                      ).parse(_checkInController.text);
                      final checkOut = DateFormat(
                        'dd/MM/yyyy',
                      ).parse(_checkOutController.text);
                      final isAvailable = await bookingProvider
                          .checkAvailability(room.id, checkIn, checkOut);
                      if (!isAvailable) {
                        Fluttertoast.showToast(
                          msg:
                              'Phòng không khả dụng trong khoảng thời gian này',
                          backgroundColor: Colors.red,
                        );
                        return;
                      }
                      // === GIẢI THÍCH: Kiểm tra và apply voucher nếu có mã ===
                      // Lý do: Gọi provider để kiểm tra voucher trước khi tạo booking, đảm bảo giảm giá được áp dụng ===
                      if (_voucherCode.isNotEmpty) {
                        await voucherProvider.applyVoucher(_voucherCode);
                        if (voucherProvider.errorMessage != null) {
                          Fluttertoast.showToast(
                            msg: voucherProvider.errorMessage!,
                            backgroundColor: Colors.red,
                          );
                          return;
                        }
                      }
                      // === GIẢI THÍCH: Gọi tạo booking và xử lý kết quả ===
                      // Lý do: Đảm bảo chuyển hướng đến BookingSuccessScreen sau khi thành công ===
                      final booking = await bookingProvider.createBooking(
                        roomId: room.id,
                        comboId: _comboId,
                        startTime: checkIn,
                        endTime: checkOut,
                        drinkIds: _drinkIds.isNotEmpty ? _drinkIds : null,
                      );
                      if (booking != null) {
                        Fluttertoast.showToast(
                          msg: 'Đặt phòng thành công',
                          backgroundColor: Colors.green,
                        );
                        // === GIẢI THÍCH: Chuyển hướng đến màn hình thành công ===
                        // Lý do: Đáp ứng yêu cầu hiển thị BookingSuccessScreen khi xác nhận ===
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    BookingSuccessScreen(booking: booking),
                          ),
                        );
                      }
                    } catch (e) {
                      String errorMessage = e.toString().replaceFirst(
                        'Exception: ',
                        '',
                      );
                      try {
                        final json = jsonDecode(e.toString().split(': ').last);
                        errorMessage = json['message'] ?? errorMessage;
                      } catch (_) {}
                      Fluttertoast.showToast(
                        msg: errorMessage,
                        backgroundColor: Colors.red,
                      );
                      if (errorMessage.contains(
                            'Invalid or missing user ID in token',
                          ) ||
                          errorMessage.contains('User must be logged in')) {
                        await Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).logout();
                        Navigator.pushNamed(
                          context,
                          '/login',
                          arguments: {
                            'redirectRoute': '/booking-form',
                            'redirectArguments': room,
                          },
                        );
                      }
                    }
                  },
                  child: const Text('Xác Nhận Đặt Phòng'),
                ),
          ],
        ),
      ),
    );
  }
}
