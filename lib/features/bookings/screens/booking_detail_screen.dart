import 'package:flutter/material.dart';
import '../models/booking.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Booking booking =
        ModalRoute.of(context)!.settings.arguments as Booking;

    return Scaffold(
      appBar: AppBar(title: Text('Booking ID ${booking.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Room ID: ${booking.roomId}'),
            Text('Check In: ${booking.checkIn.toLocal()}'),
            Text('Check Out: ${booking.checkOut.toLocal()}'),
            Text('Total Price: ${booking.totalPrice.toStringAsFixed(0)} VNĐ'),
            Text('Status: ${booking.status}'),
            if (booking.bookingDrinks.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Drinks:'),
              ...booking.bookingDrinks.map(
                (bd) => Text('- Drink ID ${bd.drinkId} x ${bd.quantity}'),
              ),
            ],
            const SizedBox(height: 16),
            if (booking.status == 'Pending')
              ElevatedButton(
                onPressed: () async {
                  try {
                    await Provider.of<BookingProvider>(
                      context,
                      listen: false,
                    ).confirmBooking(booking.id);
                    Fluttertoast.showToast(msg: 'Xác nhận thành công!');
                    Navigator.pop(context);
                  } catch (e) {
                    Fluttertoast.showToast(msg: 'Xác nhận thất bại: $e');
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
