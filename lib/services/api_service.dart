import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/costume_model.dart';

class ApiService {
  static const String _url =
      'https://raw.githubusercontent.com/ilhamharun17/kostum-adat/main/costumes.json';

  static Future<List<Costume>> fetchCostumes() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data =
          (json.decode(response.body)['costumes'] as List)
              .cast<Map<String, dynamic>>();
      return data.map((e) => Costume.fromJson(e)).toList();
    } else {
      throw Exception('HTTP ${response.statusCode}: Gagal memuat data');
    }
  }
}
