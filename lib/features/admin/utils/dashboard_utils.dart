import 'package:flutter/material.dart';
import 'package:hotel_booking_frontend/features/bookings/models/booking.dart';
import 'package:hotel_booking_frontend/features/rooms/models/room.dart';
import '../models/staff_shift.dart';
import '../widgets/dashboard_widgets.dart';

class DashboardUtils {
  static List<ActivityItem> generateRecentActivities({
    required List<Booking> bookings,
    required List<Room> rooms,
    required List<StaffShift> shifts,
  }) {
    List<ActivityItem> activities = [];

    // Recent bookings
    final recentBookings = bookings.take(3);
    for (var booking in recentBookings) {
      activities.add(
        ActivityItem(
          icon: Icons.book_online,
          color: Colors.green,
          title: 'Booking mới #${booking.id}',
          subtitle: 'Phòng ${booking.roomId} - ${booking.totalPrice}đ',
          time: _formatTime(booking.createdAt ?? DateTime.now()),
        ),
      );
    }

    // Recent room updates
    final availableRooms = rooms.where((r) => r.isAvailable).take(2);
    for (var room in availableRooms) {
      activities.add(
        ActivityItem(
          icon: Icons.room_service,
          color: Colors.blue,
          title: 'Phòng ${room.roomNumber} sẵn sàng',
          subtitle: 'Đã dọn dẹp và kiểm tra',
          time: '30 phút trước',
        ),
      );
    }

    // Recent shifts
    final todayShifts = shifts
        .where((s) => s.shiftDate.day == DateTime.now().day)
        .take(2);
    for (var shift in todayShifts) {
      activities.add(
        ActivityItem(
          icon: Icons.schedule,
          color: Colors.orange,
          title: 'Ca ${shift.shiftTime} đã được xếp',
          subtitle: 'Nhân viên ID: ${shift.staffId}',
          time: '1 giờ trước',
        ),
      );
    }

    activities.sort((a, b) => b.time.compareTo(a.time));
    return activities;
  }

  static List<ChartData> generateBookingChart(List<Booking> bookings) {
    final now = DateTime.now();
    final data = <ChartData>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayBookings =
          bookings
              .where(
                (b) =>
                    b.createdAt?.day == date.day &&
                    b.createdAt?.month == date.month,
              )
              .length;
      data.add(ChartData(6 - i, dayBookings));
    }

    return data;
  }

  static String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else {
      return '${difference.inDays} ngày trước';
    }
  }

  static double calculateOccupancyRate(
    List<Room> rooms,
    List<Booking> bookings,
  ) {
    if (rooms.isEmpty) return 0.0;

    final today = DateTime.now();
    final todayBookings =
        bookings
            .where(
              (b) =>
                  b.checkIn.day == today.day &&
                  b.checkIn.month == today.month &&
                  b.checkIn.year == today.year,
            )
            .length;
    return (todayBookings / rooms.length) * 100;
  }

  static double calculateRevenue(List<Booking> bookings) {
    final now = DateTime.now();
    final thisMonthBookings = bookings.where(
      (b) => b.createdAt?.month == now.month && b.createdAt?.year == now.year,
    );

    return thisMonthBookings.fold(
      0.0,
      (sum, booking) => sum + booking.totalPrice,
    );
  }
}
