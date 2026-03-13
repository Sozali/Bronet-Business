import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const _base = 'http://localhost:8080';

class BookingApi {
  static Future<List<Map<String, dynamic>>> fetchBookings() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/bookings'))
          .timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        return list.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  static Future<bool> updateStatus(String id, String status) async {
    try {
      final res = await http.put(
        Uri.parse('$_base/bookings/${Uri.encodeComponent(id)}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      ).timeout(const Duration(seconds: 3));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<bool?> getBusinessOpen() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/status'))
          .timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return data['isOpen'] as bool?;
      }
    } catch (_) {}
    return null;
  }

  static Future<bool?> setBusinessOpen(bool isOpen) async {
    try {
      final res = await http.put(
        Uri.parse('$_base/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'isOpen': isOpen}),
      ).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return data['isOpen'] as bool?;
      }
    } catch (_) {}
    return null;
  }
}
