import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';

class ShiftManagementScreen extends StatefulWidget {
  const ShiftManagementScreen({super.key});

  @override
  State<ShiftManagementScreen> createState() => _ShiftManagementScreenState();
}

class _ShiftManagementScreenState extends State<ShiftManagementScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(
        context,
        listen: false,
      ).fetchShifts(selectedDate.millisecondsSinceEpoch);
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Quản Lý Ca Làm')),
      body: Column(
        children: [
          // Chọn ngày để xem ca làm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Ngày: ${selectedDate.toLocal().toString().split(' ')[0]}',
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 30),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                      adminProvider.fetchShifts(
                        selectedDate.millisecondsSinceEpoch,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child:
                adminProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      itemCount: adminProvider.shifts.length,
                      itemBuilder: (context, index) {
                        final shift = adminProvider.shifts[index];
                        return ListTile(
                          title: Text('Nhân viên ID: ${shift.staffId}'),
                          subtitle: Text(
                            'Ca: ${shift.shiftTime} - Trạng thái: ${shift.status}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Sửa ca làm
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Xóa ca làm
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
              onPressed: () {
                // Thêm ca làm mới
              },
              child: const Text('Thêm Ca Làm'),
            ),
          ),
        ],
      ),
    );
  }
}
