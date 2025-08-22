import 'package:flutter/material.dart';
import '../../auth/models/user.dart';
import '../providers/admin_provider.dart';
import 'package:provider/provider.dart';
import '../dto/admin_user_update_dto.dart';
import '../dto/staff_shift_create_dto.dart';

class StaffCard extends StatelessWidget {
  final User user;

  const StaffCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(user.fullName),
        subtitle: Text('Email: ${user.email} - Role: ${user.role}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showUpdateRoleDialog(context, adminProvider),
            ),
            IconButton(
              icon: const Icon(Icons.schedule),
              onPressed: () => _showAssignShiftDialog(context, adminProvider),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateRoleDialog(BuildContext context, AdminProvider provider) {
    int? newRoleId;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Thay Đổi Role'),
              content: DropdownButton<int>(
                hint: const Text('Chọn Role'),
                value: newRoleId,
                onChanged: (value) {
                  setState(() => newRoleId = value);
                },
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Admin')),
                  DropdownMenuItem(value: 2, child: Text('Manager')),
                  DropdownMenuItem(value: 3, child: Text('Staff')),
                  DropdownMenuItem(value: 4, child: Text('Customer')),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (newRoleId != null) {
                      final dto = AdminUserUpdateDto(
                        userId: user.id,
                        roleId: newRoleId!,
                      );
                      try {
                        await provider.updateUserRole(dto);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cập nhật role thành công'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                      }
                    }
                  },
                  child: const Text('Xác Nhận'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAssignShiftDialog(BuildContext context, AdminProvider provider) {
    DateTime? shiftDate = DateTime.now();
    String? shiftTime;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Gán Ca Làm Việc'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => shiftDate = date);
                      }
                    },
                    child: Text(
                      shiftDate == null ? 'Chọn Ngày' : shiftDate.toString(),
                    ),
                  ),
                  DropdownButton<String>(
                    hint: const Text('Chọn Thời Gian'),
                    value: shiftTime,
                    onChanged: (value) {
                      setState(() => shiftTime = value);
                    },
                    items: const [
                      DropdownMenuItem(value: 'Morning', child: Text('Sáng')),
                      DropdownMenuItem(
                        value: 'Afternoon',
                        child: Text('Chiều'),
                      ),
                      DropdownMenuItem(value: 'Night', child: Text('Tối')),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (shiftDate != null && shiftTime != null) {
                      final dto = StaffShiftCreateDto(
                        staffId: user.id,
                        shiftDate: shiftDate!,
                        shiftTime: shiftTime!,
                      );
                      try {
                        await provider.assignShift(dto);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gán ca thành công')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                      }
                    }
                  },
                  child: const Text('Xác Nhận'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
