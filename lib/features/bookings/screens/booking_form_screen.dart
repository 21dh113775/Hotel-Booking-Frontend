import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});

  @override
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(days: 1));
  int _roomId = 1; // Default
  int? _comboId;
  List<int> _drinkIds = [];

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Đặt Phòng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Room ID'),
                keyboardType: TextInputType.number,
                validator:
                    (value) => value!.isEmpty ? 'Vui lòng nhập Room ID' : null,
                onChanged: (value) => _roomId = int.tryParse(value) ?? 1,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Combo ID (tùy chọn)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _comboId = int.tryParse(value),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        'Check In: ${DateFormat('dd/MM/yyyy HH:mm').format(_startTime)}',
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startTime,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2026),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_startTime),
                          );
                          if (time != null) {
                            setState(
                              () =>
                                  _startTime = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time.hour,
                                    time.minute,
                                  ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        'Check Out: ${DateFormat('dd/MM/yyyy HH:mm').format(_endTime)}',
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _endTime,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2026),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_endTime),
                          );
                          if (time != null) {
                            setState(
                              () =>
                                  _endTime = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time.hour,
                                    time.minute,
                                  ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await bookingProvider.createBooking({
                        'roomId': _roomId,
                        'comboId': _comboId,
                        'userId': 1, // Lấy từ JWT
                        'startTime': _startTime.toUtc().toIso8601String(),
                        'endTime': _endTime.toUtc().toIso8601String(),
                        'drinkIds': _drinkIds,
                      });
                      Fluttertoast.showToast(msg: 'Đặt phòng thành công!');
                      Navigator.pushNamed(context, '/bookings');
                    } catch (e) {
                      Fluttertoast.showToast(msg: 'Đặt phòng thất bại: $e');
                    }
                  }
                },
                child: const Text('Đặt Phòng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
