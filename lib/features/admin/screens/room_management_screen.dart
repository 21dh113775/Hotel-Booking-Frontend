import 'package:flutter/material.dart';
import 'package:hotel_booking_frontend/features/admin/dto/room/room_create_dto.dart';
import 'package:hotel_booking_frontend/features/admin/dto/room/room_update_dto.dart';
import 'package:hotel_booking_frontend/features/rooms/models/room.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed:
                                    () => _showEditRoomDialog(
                                      context,
                                      adminProvider,
                                      room,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
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
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: const Text('Hủy'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                adminProvider.deleteRoom(
                                                  room.id,
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Xóa'),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                              ),
                            ],
                          ),
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
    final _descriptionController = TextEditingController();
    File? _image;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm Phòng Mới'),
            content: SingleChildScrollView(
              child: Column(
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
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Mô Tả'),
                  ),
                  const SizedBox(height: 8),
                  _image != null
                      ? Image.file(_image!, height: 100)
                      : const SizedBox(),
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          _image = File(pickedFile.path);
                        });
                      }
                    },
                    child: const Text('Chọn Hình Ảnh'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final dto = RoomCreateDto(
                    roomNumber: _roomNumberController.text,
                    pricePerNight: double.tryParse(_priceController.text) ?? 0,
                    isAvailable: true,
                    description: _descriptionController.text,
                    image: _image,
                  );
                  provider.createRoom(dto);
                  Navigator.pop(context);
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  void _showEditRoomDialog(
    BuildContext context,
    AdminProvider provider,
    Room room,
  ) {
    final _roomNumberController = TextEditingController(text: room.roomNumber);
    final _priceController = TextEditingController(
      text: room.pricePerNight.toString(),
    );
    final _isAvailableController = TextEditingController(
      text: room.isAvailable.toString(),
    );
    final _descriptionController = TextEditingController(
      text: room.description ?? '',
    );
    File? _image;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Chỉnh Sửa Phòng'),
            content: SingleChildScrollView(
              child: Column(
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
                    controller: _isAvailableController,
                    decoration: const InputDecoration(
                      labelText: 'Có Sẵn (true/false)',
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Mô Tả'),
                  ),
                  const SizedBox(height: 8),
                  _image != null
                      ? Image.file(_image!, height: 100)
                      : const SizedBox(),
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          _image = File(pickedFile.path);
                        });
                      }
                    },
                    child: const Text('Chọn Hình Ảnh'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final dto = RoomUpdateDto(
                    roomNumber: _roomNumberController.text,
                    pricePerNight: double.tryParse(_priceController.text) ?? 0,
                    isAvailable:
                        _isAvailableController.text.toLowerCase() == 'true',
                    description: _descriptionController.text,
                    image: _image,
                    id: room.id,
                  );
                  provider.updateRoom(room.id, dto);
                  Navigator.pop(context);
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
    );
  }
}
