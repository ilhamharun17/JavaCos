import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/costume_model.dart';

class ApiService {
  static Future<List<Costume>> fetchCostumes() async {
    const String url =
        'https://raw.githubusercontent.com/ilhamharun17/kostum-adat/refs/heads/main/costumes.json';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data kostum');
    }

    final data = json.decode(response.body);
    final List list = data['costumes'];

    return list.map((e) => Costume.fromJson(e)).toList();
  }
}
