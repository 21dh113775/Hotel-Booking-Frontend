import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';
import '../widgets/room_card.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RoomProvider>(context, listen: false).fetchRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context);

    if (roomProvider.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Fluttertoast.showToast(
          msg: roomProvider.errorMessage!,
          backgroundColor: Colors.red,
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Danh Sách Phòng')),
      body:
          roomProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : roomProvider.rooms.isEmpty
              ? const Center(child: Text('Không có phòng nào'))
              : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: roomProvider.rooms.length,
                itemBuilder: (context, index) {
                  return RoomCard(room: roomProvider.rooms[index]);
                },
              ),
    );
  }
}
