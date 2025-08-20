import 'package:flutter/material.dart';
import 'package:hotel_booking_frontend/features/rooms/screens/room_detail_screen.dart';
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
import 'features/bookings/screens/booking_form_screen.dart';
import 'features/bookings/screens/booking_list_screen.dart';
import 'features/bookings/screens/booking_detail_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => RoomProvider()),
        ChangeNotifierProvider(create: (context) => BookingProvider()),
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
      },
    );
  }
}
