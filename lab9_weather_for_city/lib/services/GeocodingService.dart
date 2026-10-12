
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/CityModel.dart';

class GeocodingService {
  static const String baseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  Future<List<CityModel>> searchCities(String cityName) async {
    if (cityName.trim().isEmpty) {
      return [];
    }

    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'name': cityName.trim(),
        'count': '5',
        'language': 'en',
        'format': 'json',
      },
    );

    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'Geocoding API error: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> json =
    jsonDecode(response.body);

    final results = json['results'];

    if (results == null) {
      return [];
    }

    final cities = results as List<dynamic>;

    return cities.map((item) {
      return CityModel.fromJson(
        item as Map<String, dynamic>,
      );
    }).toList();
  }
}
