
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/WeatherModel.dart';

class WeatherService {
  static const String baseUrl =
      'https://api.open-meteo.com/v1/forecast';

  Future<WeatherModel> fetchWeather(
      {required double latitude,
      required double longitude}
      ) async {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current':
        'temperature_2m,relative_humidity_2m,'
            'apparent_temperature,precipitation,'
            'weather_code,wind_speed_10m',
        'timezone': 'auto',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to load weather: ${response.statusCode}',
      );
    }
  }
}
