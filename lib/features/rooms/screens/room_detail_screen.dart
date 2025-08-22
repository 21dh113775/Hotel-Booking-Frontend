import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/room.dart';

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Room room = ModalRoute.of(context)!.settings.arguments as Room;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Phòng ${room.roomNumber}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (room.imageUrl != null && room.imageUrl!.isNotEmpty)
              Center(
                child: Image.network(
                  'https://localhost:7284${room.imageUrl}',
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.error, size: 100),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              'Phòng: ${room.roomNumber}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Giá: ${room.pricePerNight.toStringAsFixed(0)} VNĐ/đêm'),
            Text('Trạng thái: ${room.isAvailable ? "Còn trống" : "Đã đặt"}'),
            if (room.description != null && room.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Mô tả: ${room.description}'),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  room.isAvailable
                      ? () {
                        if (authProvider.isLoggedIn) {
                          Navigator.pushNamed(
                            context,
                            '/booking-form',
                            arguments: room,
                          );
                        } else {
                          // Lưu room để quay lại sau khi đăng nhập
                          Navigator.pushNamed(
                            context,
                            '/login',
                            arguments: {
                              'redirectRoute': '/booking-form',
                              'redirectArguments': room,
                            },
                          );
                        }
                      }
                      : null,
              child: const Text('Đặt Phòng'),
            ),
          ],
        ),
      ),
    );
  }
}
