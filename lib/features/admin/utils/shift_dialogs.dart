import 'package:flutter/material.dart';
import 'package:hotel_booking_frontend/features/admin/dto/staff/staff_shift_create_dto.dart';
import 'package:hotel_booking_frontend/features/admin/dto/staff/staff_shift_update_dto.dart';
import 'package:hotel_booking_frontend/features/admin/models/staff_shift.dart';
import 'package:hotel_booking_frontend/features/admin/providers/admin_provider.dart';

class ShiftDialogs {
  static void showAddShiftDialog(
    BuildContext context,
    AdminProvider provider,
    int staffId,
    String shiftTime,
    DateTime selectedDate,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                Icon(Icons.add_circle, color: Colors.green.shade700),
                const SizedBox(width: 8),
                const Text('Thêm Ca Làm'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ca làm: ${_getShiftDisplayName(shiftTime)}'),
                      Text('Ngày: ${_formatDate(selectedDate)}'),
                      Text('Nhân viên ID: $staffId'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Bạn có chắc chắn muốn thêm ca làm này?',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  final dto = StaffShiftCreateDto(
                    staffId: staffId,
                    shiftDate: selectedDate,
                    shiftTime: shiftTime,
                  );
                  provider.assignShift(dto);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm ca $shiftTime thành công'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  static void showEditShiftDialog(
    BuildContext context,
    AdminProvider provider,
    StaffShift shift,
  ) {
    String selectedShiftTime = shift.shiftTime;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      const Text('Chỉnh Sửa Ca Làm'),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ngày: ${_formatDate(shift.shiftDate)}'),
                            Text('Nhân viên ID: ${shift.staffId}'),
                            const SizedBox(height: 8),
                            const Text('Chọn ca làm mới:'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedShiftTime,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Ca làm',
                        ),
                        items:
                            ['Morning', 'Afternoon', 'Night']
                                .map(
                                  (time) => DropdownMenuItem(
                                    value: time,
                                    child: Text(_getShiftDisplayName(time)),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) =>
                                setState(() => selectedShiftTime = value!),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final dto = StaffShiftUpdateDto(
                          staffId: shift.staffId,
                          shiftDate: shift.shiftDate,
                          shiftTime: selectedShiftTime,
                          id: shift.id,
                        );
                        provider.updateShift(shift.id, dto);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đã cập nhật ca làm thành công'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Lưu'),
                    ),
                  ],
                ),
          ),
    );
  }

  static void showDeleteConfirmDialog(
    BuildContext context,
    AdminProvider provider,
    int shiftId,
    int staffId,
    String shiftTime,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.red.shade700),
                const SizedBox(width: 8),
                const Text('Xác nhận xóa'),
              ],
            ),
            content: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bạn có chắc chắn muốn xóa ca ${_getShiftDisplayName(shiftTime)}?',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hành động này không thể hoàn tác.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
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
                  provider.deleteShift(shiftId, staffId);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã xóa ca làm thành công'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  static String _getShiftDisplayName(String shiftTime) {
    switch (shiftTime) {
      case 'Morning':
        return 'Ca Sáng (6:00 - 14:00)';
      case 'Afternoon':
        return 'Ca Chiều (14:00 - 22:00)';
      case 'Night':
        return 'Ca Đêm (22:00 - 6:00)';
      default:
        return shiftTime;
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
