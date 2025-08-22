import 'package:flutter/material.dart';
import '../models/booking.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          'Booking #${booking.id} - Phòng ${booking.room?.roomNumber ?? booking.roomId}',
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Check-in: ${DateFormat('dd/MM/yyyy').format(booking.checkIn)}',
            ),
            Text(
              'Check-out: ${DateFormat('dd/MM/yyyy').format(booking.checkOut)}',
            ),
            Text('Tổng: ${booking.totalPrice.toStringAsFixed(0)} VNĐ'),
            Text('Trạng thái: ${booking.status}'),
          ],
        ),
        onTap: () {
          // TODO: Chuyển sang màn hình chi tiết booking nếu cần
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking #${booking.id} selected')),
          );
        },
      ),
    );
  }
}
