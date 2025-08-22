// lib/bookings/widgets/date_picker.dart
import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePicker({
    Key? key,
    required this.label,
    this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
            );
            if (date != null) {
              onDateSelected(date);
            }
          },
          child: Text(
            selectedDate != null
                ? selectedDate!.toLocal().toString().substring(0, 10)
                : 'Select Date',
          ),
        ),
      ],
    );
  }
}
