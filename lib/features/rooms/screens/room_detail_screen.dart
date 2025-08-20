import 'package:flutter/material.dart';
import '../models/room.dart';

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Room room = ModalRoute.of(context)!.settings.arguments as Room;

    return Scaffold(
      appBar: AppBar(title: Text('Phòng ${room.roomNumber}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (room.imageUrl != null)
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
            if (room.description != null) ...[
              const SizedBox(height: 8),
              Text('Mô tả: ${room.description}'),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  room.isAvailable
                      ? () {
                        // TODO: Chuyển sang màn hình đặt phòng (Bước 2.3)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Chuyển sang đặt phòng'),
                          ),
                        );
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
