import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../dto/staff_shift_create_dto.dart';

class ShiftManagementScreen extends StatefulWidget {
  const ShiftManagementScreen({super.key});

  @override
  _ShiftManagementScreenState createState() => _ShiftManagementScreenState();
}

class _ShiftManagementScreenState extends State<ShiftManagementScreen> {
  int _selectedStaffId = 1; // Default, sẽ load từ list staff

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(
        context,
        listen: false,
      ).fetchShifts(_selectedStaffId); // Fetch cho staff đầu tiên
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    final staffList =
        adminProvider.users
            .where((user) => user.role == 'Staff')
            .toList(); // Lấy thông tin staff từ users

    return Scaffold(
      appBar: AppBar(title: const Text('Quản Lý Ca Làm')),
      body:
          adminProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : adminProvider.errorMessage != null
              ? Center(child: Text(adminProvider.errorMessage!))
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<int>(
                      value: _selectedStaffId,
                      items:
                          staffList
                              .map(
                                (staff) => DropdownMenuItem(
                                  value: staff.id,
                                  child: Text(staff.fullName),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() => _selectedStaffId = value!);
                        adminProvider.fetchShifts(_selectedStaffId);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: adminProvider.shifts.length,
                      itemBuilder: (context, index) {
                        final shift = adminProvider.shifts[index];
                        return ListTile(
                          title: Text('Ca ${shift.shiftTime}'),
                          subtitle: Text('Ngày: ${shift.shiftDate.toLocal()}'),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Xác nhận xóa'),
                                    content: const Text(
                                      'Bạn có chắc muốn xóa ca này?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Hủy'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          adminProvider.deleteShift(
                                            shift.id,
                                            _selectedStaffId,
                                          );
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
                          () => _showAddShiftDialog(context, adminProvider),
                      child: const Text('Thêm Ca Làm'),
                    ),
                  ),
                ],
              ),
    );
  }

  void _showAddShiftDialog(BuildContext context, AdminProvider provider) {
    final _dateController = TextEditingController();
    String? _shiftTime;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm Ca Làm Mới'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Ngày (yyyy-MM-dd)',
                  ),
                ),
                DropdownButton<String>(
                  hint: const Text('Chọn Ca'),
                  value: _shiftTime,
                  items:
                      const ['Morning', 'Afternoon', 'Night']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _shiftTime = value),
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
                  if (_dateController.text.isNotEmpty && _shiftTime != null) {
                    final dto = StaffShiftCreateDto(
                      staffId: _selectedStaffId,
                      shiftDate: DateTime.parse(_dateController.text),
                      shiftTime: _shiftTime!,
                    );
                    provider.assignShift(dto);
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
