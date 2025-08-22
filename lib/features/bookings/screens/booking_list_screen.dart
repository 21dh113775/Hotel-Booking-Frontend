import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_card.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Danh Sách Đặt Phòng')),
      body:
          bookingProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : bookingProvider.errorMessage != null
              ? Center(child: Text(bookingProvider.errorMessage!))
              : bookingProvider.bookings.isEmpty
              ? const Center(child: Text('Không có đặt phòng nào'))
              : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: bookingProvider.bookings.length,
                itemBuilder: (context, index) {
                  return BookingCard(booking: bookingProvider.bookings[index]);
                },
              ),
    );
  }
}
