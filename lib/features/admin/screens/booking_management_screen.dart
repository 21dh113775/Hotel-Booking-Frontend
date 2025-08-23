import 'package:flutter/material.dart';
import 'package:hotel_booking_frontend/features/admin/dto/booking/booking_update_dto.dart';
import 'package:hotel_booking_frontend/features/bookings/models/booking.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../../bookings/widgets/booking_card.dart';

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  _BookingManagementScreenState createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Quản Lý Booking')),
      body:
          adminProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : adminProvider.errorMessage != null
              ? Center(child: Text(adminProvider.errorMessage!))
              : ListView.builder(
                itemCount: adminProvider.bookings.length,
                itemBuilder: (context, index) {
                  final booking = adminProvider.bookings[index];
                  return ListTile(
                    title: Text('Booking #${booking.id}'),
                    subtitle: Text(
                      'Phòng: ${booking.roomId}, Trạng thái: ${booking.status}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed:
                          () => _showEditBookingDialog(
                            context,
                            adminProvider,
                            booking,
                          ),
                    ),
                  );
                },
              ),
    );
  }

  void _showEditBookingDialog(
    BuildContext context,
    AdminProvider provider,
    Booking booking,
  ) {
    final _statusController = TextEditingController(text: booking.status);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Chỉnh Sửa Booking'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _statusController,
                  decoration: const InputDecoration(
                    labelText: 'Trạng thái (Pending/Confirmed/Cancelled)',
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
                  final dto = BookingUpdateDto(
                    id: booking.id,
                    status: _statusController.text,
                    checkIn: booking.checkIn,
                    checkOut: booking.checkOut,
                  );
                  provider.updateBooking(dto);
                  Navigator.pop(context);
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
    );
  }
}
