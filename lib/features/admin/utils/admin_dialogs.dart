import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../dto/room/room_create_dto.dart';
import '../dto/voucher/voucher_create_dto.dart';
import '../dto/staff/staff_shift_create_dto.dart';
import '../providers/admin_provider.dart';

class AdminDialogs {
  static Widget buildAddRoomDialog(
    BuildContext context,
    AdminProvider provider,
  ) {
    final roomNumberController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();
    File? selectedImage;
    String selectedRoomType = 'Standard';

    return StatefulBuilder(
      builder:
          (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.hotel, color: Colors.green),
                ),
                const SizedBox(width: 12),
                const Text('Thêm phòng mới'),
              ],
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: roomNumberController,
                            decoration: const InputDecoration(
                              labelText: 'Số phòng',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.room),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedRoomType,
                            decoration: const InputDecoration(
                              labelText: 'Loại phòng',
                              border: OutlineInputBorder(),
                            ),
                            items:
                                ['Standard', 'Deluxe', 'Suite', 'VIP']
                                    .map(
                                      (type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                (value) =>
                                    setState(() => selectedRoomType = value!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Giá mỗi đêm (VND)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả phòng',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          selectedImage != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Chọn ảnh phòng',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final picker = ImagePicker();
                              final picked = await picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (picked != null) {
                                setState(
                                  () => selectedImage = File(picked.path),
                                );
                              }
                            },
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Thư viện'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final picker = ImagePicker();
                              final picked = await picker.pickImage(
                                source: ImageSource.camera,
                              );
                              if (picked != null) {
                                setState(
                                  () => selectedImage = File(picked.path),
                                );
                              }
                            },
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Chụp ảnh'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (roomNumberController.text.isNotEmpty &&
                      priceController.text.isNotEmpty) {
                    final dto = RoomCreateDto(
                      roomNumber: roomNumberController.text,
                      pricePerNight: double.parse(priceController.text),
                      isAvailable: true,
                      description: descriptionController.text,
                      image: selectedImage,
                    );
                    provider.createRoom(dto);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thêm phòng thành công'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Thêm phòng'),
              ),
            ],
          ),
    );
  }

  static Widget buildAddVoucherDialog(
    BuildContext context,
    AdminProvider provider,
  ) {
    final codeController = TextEditingController();
    final discountController = TextEditingController();
    final expiryController = TextEditingController();
    String discountType = 'percentage';

    return StatefulBuilder(
      builder:
          (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.local_offer, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                const Text('Tạo voucher mới'),
              ],
            ),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      labelText: 'Mã voucher',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.confirmation_number),
                      hintText: 'VD: SUMMER2024',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: discountController,
                          decoration: InputDecoration(
                            labelText:
                                discountType == 'percentage'
                                    ? 'Giảm (%)'
                                    : 'Giảm (VND)',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.percent),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: discountType,
                        items: const [
                          DropdownMenuItem(
                            value: 'percentage',
                            child: Text('Phần trăm'),
                          ),
                          DropdownMenuItem(
                            value: 'fixed',
                            child: Text('Cố định'),
                          ),
                        ],
                        onChanged:
                            (value) => setState(() => discountType = value!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: expiryController,
                    decoration: const InputDecoration(
                      labelText: 'Ngày hết hạn',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: 'dd/mm/yyyy',
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(
                          const Duration(days: 30),
                        ),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        expiryController.text =
                            '${date.day}/${date.month}/${date.year}';
                      }
                    },
                    readOnly: true,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (codeController.text.isNotEmpty &&
                      discountController.text.isNotEmpty) {
                    final parts = expiryController.text.split('/');
                    final expiryDate = DateTime(
                      int.parse(parts[2]),
                      int.parse(parts[1]),
                      int.parse(parts[0]),
                    );

                    final dto = VoucherCreateDto(
                      code: codeController.text.toUpperCase(),
                      discount: int.parse(discountController.text),
                      expiryDate: expiryDate,
                    );
                    provider.createVoucher(dto);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tạo voucher thành công'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Tạo voucher'),
              ),
            ],
          ),
    );
  }
}
