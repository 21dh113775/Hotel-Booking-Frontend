import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';

class BookingSuccessScreen extends StatelessWidget {
  final Booking booking;

  const BookingSuccessScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt Phòng Thành Công')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === GIẢI THÍCH: Hiển thị thông báo chúc mừng ===
            // Lý do: Cung cấp phản hồi tích cực cho người dùng sau khi đặt phòng ===
            const Text(
              'Chúc mừng! Bạn đã đặt phòng thành công!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text('Mã đặt phòng: ${booking.id}'),
            Text('Phòng: ${booking.room?.roomNumber ?? "N/A"}'),
            Text(
              'Check-in: ${DateFormat('dd/MM/yyyy').format(booking.checkIn)}',
            ),
            Text(
              'Check-out: ${DateFormat('dd/MM/yyyy').format(booking.checkOut)}',
            ),
            Text('Tổng giá: ${booking.totalPrice.toStringAsFixed(0)} VNĐ'),
            Text('Trạng thái: ${booking.status}'),
            if (booking.combo != null) Text('Combo: ${booking.combo!.name}'),
            // === GIẢI THÍCH: Hiển thị danh sách đồ uống nếu có ===
            // Lý do: Đảm bảo chi tiết booking đầy đủ, bao gồm bookingDrinks từ backend ===
            if (booking.bookingDrinks != null &&
                booking.bookingDrinks!.isNotEmpty)
              Text(
                'Đồ uống: ${booking.bookingDrinks!.map((bd) => "${bd.drink.name} x${bd.quantity}").join(", ")}',
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/bookings');
              },
              child: const Text('Xem Danh Sách Đặt Phòng'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Quay Về Trang Chủ'),
            ),
          ],
        ),
      ),
    );
  }
}
