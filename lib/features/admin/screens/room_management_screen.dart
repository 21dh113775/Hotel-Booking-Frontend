import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../dto/room_create_dto.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RoomManagementScreen extends StatefulWidget {
  const RoomManagementScreen({super.key});

  @override
  _RoomManagementScreenState createState() => _RoomManagementScreenState();
}

class _RoomManagementScreenState extends State<RoomManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Quản Lý Phòng')),
      body:
          adminProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : adminProvider.errorMessage != null
              ? Center(child: Text(adminProvider.errorMessage!))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: adminProvider.rooms.length,
                      itemBuilder: (context, index) {
                        final room = adminProvider.rooms[index];
                        return ListTile(
                          title: Text('Phòng ${room.roomNumber}'),
                          subtitle: Text(
                            'Giá: ${room.pricePerNight}, Trạng thái: ${room.isAvailable ? "Có sẵn" : "Đã đặt"}',
                          ),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Xác nhận xóa'),
                                    content: const Text(
                                      'Bạn có chắc muốn xóa phòng này?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Hủy'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          adminProvider.deleteRoom(room.id);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Xóa'),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed:
                          () => _showAddRoomDialog(context, adminProvider),
                      child: const Text('Thêm Phòng'),
                    ),
                  ),
                ],
              ),
    );
  }

  void _showAddRoomDialog(BuildContext context, AdminProvider provider) {
    final _roomNumberController = TextEditingController();
    final _priceController = TextEditingController();
    String? _description;
    File? _image;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm Phòng Mới'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _roomNumberController,
                  decoration: const InputDecoration(labelText: 'Số Phòng'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Giá/Đêm'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  onChanged: (value) => _description = value,
                  decoration: const InputDecoration(labelText: 'Mô Tả'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      _image = File(pickedFile.path);
                    }
                  },
                  child: const Text('Chọn Hình Ảnh'),
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
                  if (_roomNumberController.text.isNotEmpty &&
                      _priceController.text.isNotEmpty) {
                    final dto = RoomCreateDto(
                      roomNumber: _roomNumberController.text,
                      pricePerNight: double.parse(_priceController.text),
                      isAvailable: true,
                      description: _description,
                      image: _image,
                    );
                    provider.createRoom(dto);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }
}
