import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../providers/booking_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = ModalRoute.of(context)!.settings.arguments as Booking;
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Booking #${booking.id}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phòng: ${booking.room?.roomNumber ?? booking.roomId}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Check-in: ${DateFormat('dd/MM/yyyy').format(booking.checkIn)}',
            ),
            Text(
              'Check-out: ${DateFormat('dd/MM/yyyy').format(booking.checkOut)}',
            ),
            Text('Tổng: ${booking.totalPrice.toStringAsFixed(0)} VNĐ'),
            Text('Trạng thái: ${booking.status}'),
            if (booking.combo != null) ...[
              const SizedBox(height: 8),
              Text(
                'Combo: ${booking.combo!.name} (${booking.combo!.price.toStringAsFixed(0)} VNĐ)',
              ),
            ],
            if (booking.bookingDrinks != null &&
                booking.bookingDrinks!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Đồ uống:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...booking.bookingDrinks!.map(
                (bd) => Text(
                  '${bd.drink.name} x${bd.quantity} (${bd.drink.price.toStringAsFixed(0)} VNĐ)',
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (booking.status == 'Pending')
              ElevatedButton(
                onPressed:
                    bookingProvider.isLoading
                        ? null
                        : () async {
                          final success = await bookingProvider.confirmBooking(
                            booking.id,
                          );
                          if (success) {
                            Fluttertoast.showToast(
                              msg: 'Xác nhận booking thành công!',
                              backgroundColor: Colors.green,
                            );
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                              msg:
                                  bookingProvider.errorMessage ??
                                  'Xác nhận thất bại',
                              backgroundColor: Colors.red,
                            );
                          }
                        },
                child: const Text('Xác Nhận Booking'),
              ),
          ],
        ),
      ),
    );
  }
}
