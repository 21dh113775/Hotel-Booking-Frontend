class BookingUpdateDto {
  final int id;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? status;

  BookingUpdateDto({
    required this.id,
    this.checkIn,
    this.checkOut,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'id': id};
    if (checkIn != null) data['checkIn'] = checkIn!.toUtc().toIso8601String();
    if (checkOut != null)
      data['checkOut'] = checkOut!.toUtc().toIso8601String();
    if (status != null) data['status'] = status;
    return data;
  }
}
