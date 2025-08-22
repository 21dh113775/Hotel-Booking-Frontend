import 'package:flutter/material.dart';
import 'package:hotel_booking_frontend/features/admin/providers/admin_provider.dart';
import 'package:hotel_booking_frontend/features/vouchers/providers/voucher_provider.dart';
import 'package:provider/provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/rooms/providers/room_provider.dart';
import 'features/bookings/providers/booking_provider.dart';
import 'screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/profile_screen.dart';
import 'screens/home_screen.dart';
import 'features/rooms/screens/room_list_screen.dart';
import 'features/rooms/screens/room_detail_screen.dart';
import 'features/bookings/screens/booking_list_screen.dart';
import 'features/bookings/screens/booking_form_screen.dart';
import 'features/bookings/screens/booking_detail_screen.dart';
import 'features/bookings/screens/booking_success_screen.dart';
import 'features/vouchers/screens/voucher_screen.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/admin/screens/voucher_management_screen.dart';
import 'features/admin/screens/user_management_screen.dart'; // Thêm mới
import 'features/admin/screens/room_management_screen.dart'; // Thêm mới
import 'features/admin/screens/shift_management_screen.dart'; // Thêm mới
import 'features/admin/screens/booking_management_screen.dart'; // Thêm mới

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => RoomProvider()),
        ChangeNotifierProvider(create: (context) => BookingProvider()),
        ChangeNotifierProvider(create: (context) => VoucherProvider()),
        ChangeNotifierProvider(create: (context) => AdminProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking Frontend',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => const HomeScreen(),
        '/rooms': (context) => const RoomListScreen(),
        '/room-detail': (context) => const RoomDetailScreen(),
        '/booking-form': (context) => const BookingFormScreen(),
        '/bookings': (context) => const BookingListScreen(),
        '/booking-detail': (context) => const BookingDetailScreen(),
        // '/booking-success': (context) => const BookingSuccessScreen(),
        '/vouchers': (context) => const VoucherScreen(),
        '/admin/dashboard': (context) => const AdminDashboardScreen(),
        '/admin/voucher-management':
            (context) => const VoucherManagementScreen(),
        '/admin/user-management':
            (context) => const UserManagementScreen(), // Thêm
        '/admin/room-management':
            (context) => const RoomManagementScreen(), // Thêm
        '/admin/shift-management':
            (context) => const ShiftManagementScreen(), // Thêm
        '/admin/booking-management':
            (context) => const BookingManagementScreen(), // Thêm
      },
    );
  }
}
