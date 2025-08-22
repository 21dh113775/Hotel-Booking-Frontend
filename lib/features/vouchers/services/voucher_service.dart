import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../services/api_client.dart';
import '../models/voucher.dart';

class VoucherService {
  // === GIẢI THÍCH: Lấy danh sách voucher từ API ===
  // Lý do: Để hiển thị trên VoucherScreen ===
  Future<List<Voucher>> getVouchers() async {
    final response = await ApiClient.get('/api/voucher', withAuth: true);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Voucher.fromJson(json)).toList();
    } else {
      throw Exception('Lỗi lấy voucher: ${response.body}');
    }
  }

  // === GIẢI THÍCH: Áp dụng voucher và lấy chi tiết ===
  // Lý do: Kiểm tra mã và áp dụng giảm giá trong booking ===
  Future<Voucher> applyVoucher(String code) async {
    final response = await ApiClient.post(
      '/api/voucher/apply?code=$code',
      withAuth: true,
    );
    if (response.statusCode == 200) {
      return Voucher.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Lỗi apply voucher: ${response.body}');
    }
  }
}
