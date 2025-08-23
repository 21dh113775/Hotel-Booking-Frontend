import 'package:flutter/material.dart';
import 'package:hotel_booking_frontend/features/admin/dto/staff/staff_shift_create_dto.dart';
import 'package:hotel_booking_frontend/features/admin/dto/staff/staff_shift_update_dto.dart';
import 'package:hotel_booking_frontend/features/admin/models/staff_shift.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import 'dart:io';

class ShiftManagementScreen extends StatefulWidget {
  const ShiftManagementScreen({super.key});

  @override
  _ShiftManagementScreenState createState() => _ShiftManagementScreenState();
}

class _ShiftManagementScreenState extends State<ShiftManagementScreen> {
  DateTime _selectedDate = DateTime.now();
  int? _selectedStaffId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchStaffs();
      if (_selectedStaffId != null) {
        Provider.of<AdminProvider>(
          context,
          listen: false,
        ).fetchShiftsByDate(_selectedDate, _selectedStaffId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

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
                    child: Row(
                      children: [
                        Text(
                          'Ngày: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now().subtract(
                                const Duration(days: 30),
                              ),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) {
                              setState(() {
                                _selectedDate = picked;
                              });
                              if (_selectedStaffId != null) {
                                adminProvider.fetchShiftsByDate(
                                  _selectedDate,
                                  _selectedStaffId,
                                );
                              }
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        DropdownButton<int>(
                          hint: const Text('Chọn Nhân Viên'),
                          value: _selectedStaffId,
                          items:
                              adminProvider.staffs
                                  .map(
                                    (staff) => DropdownMenuItem(
                                      value: staff.id,
                                      child: Text(staff.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedStaffId = value;
                            });
                            if (value != null) {
                              adminProvider.fetchShiftsByDate(
                                _selectedDate,
                                value,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          _selectedStaffId != null
                              ? 1
                              : adminProvider.staffs.length,
                      itemBuilder: (context, index) {
                        final staff =
                            _selectedStaffId != null
                                ? adminProvider.staffs.firstWhere(
                                  (s) => s.id == _selectedStaffId,
                                )
                                : adminProvider.staffs[index];
                        final staffShifts =
                            adminProvider.shifts
                                .where(
                                  (shift) =>
                                      shift.staffId == staff.id &&
                                      shift.shiftDate.day ==
                                          _selectedDate.day &&
                                      shift.shiftDate.month ==
                                          _selectedDate.month &&
                                      shift.shiftDate.year ==
                                          _selectedDate.year,
                                )
                                .toList();
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          child: ExpansionTile(
                            title: Text('${staff.name} (ID: ${staff.id})'),
                            children: [
                              ...['Morning', 'Afternoon', 'Night'].map((
                                shiftTime,
                              ) {
                                final shift = staffShifts.firstWhere(
                                  (s) => s.shiftTime == shiftTime,
                                  orElse:
                                      () => StaffShift(
                                        id: -1,
                                        staffId: staff.id,
                                        shiftDate: _selectedDate,
                                        shiftTime: shiftTime,
                                        status: '',
                                      ),
                                );
                                return ListTile(
                                  title: Text('Ca $shiftTime'),
                                  subtitle:
                                      shift.id != -1
                                          ? Text('Đã xếp lịch')
                                          : Text('Chưa xếp lịch'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (shift.id != -1)
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed:
                                              () => _showEditShiftDialog(
                                                context,
                                                adminProvider,
                                                shift,
                                              ),
                                        ),
                                      IconButton(
                                        icon: Icon(
                                          shift.id != -1
                                              ? Icons.delete
                                              : Icons.add,
                                        ),
                                        onPressed: () {
                                          if (shift.id != -1) {
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (context) => AlertDialog(
                                                    title: const Text(
                                                      'Xác nhận xóa',
                                                    ),
                                                    content: const Text(
                                                      'Bạn có chắc muốn xóa ca này?',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              context,
                                                            ),
                                                        child: const Text(
                                                          'Hủy',
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          adminProvider
                                                              .deleteShift(
                                                                shift.id,
                                                                staff.id,
                                                              );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: const Text(
                                                          'Xóa',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            );
                                          } else {
                                            _showAddShiftDialog(
                                              context,
                                              adminProvider,
                                              staff.id,
                                              shiftTime,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  void _showAddShiftDialog(
    BuildContext context,
    AdminProvider provider,
    int staffId,
    String shiftTime,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm Ca Làm'),
            content: Text(
              'Thêm ca $shiftTime cho nhân viên $staffId vào ngày ${_selectedDate.toLocal().toString().split(' ')[0]}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final dto = StaffShiftCreateDto(
                    staffId: staffId,
                    shiftDate: _selectedDate,
                    shiftTime: shiftTime,
                  );
                  provider.assignShift(dto);
                  Navigator.pop(context);
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  void _showEditShiftDialog(
    BuildContext context,
    AdminProvider provider,
    StaffShift shift,
  ) {
    String? _shiftTime = shift.shiftTime;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Chỉnh Sửa Ca Làm'),
            content: DropdownButton<String>(
              value: _shiftTime,
              items:
                  ['Morning', 'Afternoon', 'Night']
                      .map(
                        (time) =>
                            DropdownMenuItem(value: time, child: Text(time)),
                      )
                      .toList(),
              onChanged: (value) => setState(() => _shiftTime = value),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final dto = StaffShiftUpdateDto(
                    staffId: shift.staffId,
                    shiftDate: shift.shiftDate,
                    shiftTime: _shiftTime!,
                    id: shift.id,
                  );
                  provider.updateShift(shift.id, dto);
                  Navigator.pop(context);
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
    );
  }
}
