import 'package:flutter/material.dart';
import '../models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading:
            room.imageUrl != null && room.imageUrl!.isNotEmpty
                ? Image.network(
                  'https://localhost:7284${room.imageUrl}',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(Icons.error),
                )
                : const Icon(Icons.hotel),
        title: Text('Phòng ${room.roomNumber}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Giá: ${room.pricePerNight.toStringAsFixed(0)} VNĐ/đêm'),
            Text(room.isAvailable ? 'Còn trống' : 'Đã đặt'),
            if (room.description != null && room.description!.isNotEmpty)
              Text(room.description!),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, '/room-detail', arguments: room);
        },
      ),
    );
  }
}
