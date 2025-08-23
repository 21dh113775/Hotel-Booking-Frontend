import 'package:flutter/material.dart';
import 'package:hotel_booking_frontend/features/admin/models/staff_shift.dart';
import 'package:hotel_booking_frontend/features/admin/models/staff.dart';

// Widget cho Staff Card
class StaffShiftCard extends StatelessWidget {
  final Staff staff;
  final List<StaffShift> staffShifts;
  final DateTime selectedDate;
  final Function(String, int) onAddShift;
  final Function(StaffShift) onEditShift;
  final Function(int, int) onDeleteShift;

  const StaffShiftCard({
    Key? key,
    required this.staff,
    required this.staffShifts,
    required this.selectedDate,
    required this.onAddShift,
    required this.onEditShift,
    required this.onDeleteShift,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      child: ExpansionTile(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                staff.name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    staff.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'ID: ${staff.id}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            _buildShiftSummary(),
          ],
        ),
        children: _buildShiftTiles(),
      ),
    );
  }

  Widget _buildShiftSummary() {
    final shiftCount = staffShifts.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: shiftCount > 0 ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$shiftCount/3 ca',
        style: TextStyle(
          color:
              shiftCount > 0 ? Colors.green.shade800 : Colors.orange.shade800,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Widget> _buildShiftTiles() {
    const shiftTimes = ['Morning', 'Afternoon', 'Night'];
    const shiftIcons = {
      'Morning': Icons.wb_sunny,
      'Afternoon': Icons.wb_sunny_outlined,
      'Night': Icons.nights_stay,
    };
    const shiftColors = {
      'Morning': Colors.orange,
      'Afternoon': Colors.blue,
      'Night': Colors.purple,
    };

    return shiftTimes.map((shiftTime) {
      final shift = staffShifts.firstWhere(
        (s) => s.shiftTime == shiftTime,
        orElse:
            () => StaffShift(
              id: -1,
              staffId: staff.id,
              shiftDate: selectedDate,
              shiftTime: shiftTime,
              status: '',
            ),
      );

      final isAssigned = shift.id != -1;

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          color:
              isAssigned
                  ? shiftColors[shiftTime]!.withOpacity(0.1)
                  : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isAssigned
                    ? shiftColors[shiftTime]!.withOpacity(0.3)
                    : Colors.grey.shade300,
          ),
        ),
        child: ListTile(
          leading: Icon(shiftIcons[shiftTime], color: shiftColors[shiftTime]),
          title: Text(
            _getShiftDisplayName(shiftTime),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            isAssigned ? 'Đã xếp lịch' : 'Chưa xếp lịch',
            style: TextStyle(
              color: isAssigned ? Colors.green.shade700 : Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          trailing: _buildShiftActions(shift, shiftTime, isAssigned),
        ),
      );
    }).toList();
  }

  Widget _buildShiftActions(
    StaffShift shift,
    String shiftTime,
    bool isAssigned,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isAssigned) ...[
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: Colors.blue,
            onPressed: () => onEditShift(shift),
            tooltip: 'Chỉnh sửa',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: Colors.red,
            onPressed: () => onDeleteShift(shift.id, staff.id),
            tooltip: 'Xóa ca',
          ),
        ] else
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 20),
            color: Colors.green,
            onPressed: () => onAddShift(shiftTime, staff.id),
            tooltip: 'Thêm ca',
          ),
      ],
    );
  }

  String _getShiftDisplayName(String shiftTime) {
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
}

// Widget cho Date Selector
class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const DateSelector({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ngày làm việc',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  _formatDate(selectedDate),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showDatePicker(context),
            icon: const Icon(Icons.edit_calendar, size: 16),
            label: const Text('Chọn ngày'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    const months = [
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12',
    ];

    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }
}
