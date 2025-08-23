import 'dart:convert';

class StaffShiftUpdateDto {
  final int id;
  final int staffId;
  final DateTime shiftDate;
  final String shiftTime;

  StaffShiftUpdateDto({
    required this.id,
    required this.staffId,
    required this.shiftDate,
    required this.shiftTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'staffId': staffId,
      'shiftDate': shiftDate.toUtc().toIso8601String(),
      'shiftTime': shiftTime,
    };
  }
}
