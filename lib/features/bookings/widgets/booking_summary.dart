import 'package:flutter/material.dart';
import '../models/booking.dart';

class BookingSummary extends StatelessWidget {
  final Booking booking;

  const BookingSummary({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking ID: ${booking.id}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Room ID: ${booking.roomId}'),
            Text('Check In: ${booking.checkIn.toLocal()}'),
            Text('Check Out: ${booking.checkOut.toLocal()}'),
            Text('Total Price: ${booking.totalPrice.toStringAsFixed(0)} VNĐ'),
            Text('Status: ${booking.status}'),
            if (booking.bookingDrinks.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Drinks:'),
              ...booking.bookingDrinks.map(
                (bd) => Text('- Drink ID ${bd.drinkId} x ${bd.quantity}'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
