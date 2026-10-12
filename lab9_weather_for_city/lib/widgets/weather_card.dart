
import 'package:flutter/material.dart';

import '../models/CityModel.dart';
import '../models/WeatherModel.dart';


class WeatherCard extends StatelessWidget {
  final CityModel city;
  final WeatherModel weather;

  const WeatherCard({
    super.key,
    required this.city,
    required this.weather,
  });

  String getWeatherDescription(int code) {
    if (code == 0) return 'Clear Sky';
    if (code >= 1 && code <= 3) {
      return 'Partly Cloudy';
    }
    if (code == 45 || code == 48) {
      return 'Foggy';
    }
    if ((code >= 51 && code <= 67) ||
        (code >= 80 && code <= 82)) {
      return 'Rainy';
    }
    if (code >= 71 && code <= 77) {
      return 'Snowy';
    }
    if (code >= 95) {
      return 'Thunderstorm';
    }
    return 'Unknown Weather';
  }

  IconData getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code >= 1 && code <= 3) {
      return Icons.cloud_queue;
    }
    if (code == 45 || code == 48) {
      return Icons.foggy;
    }
    if ((code >= 51 && code <= 67) ||
        (code >= 80 && code <= 82)) {
      return Icons.water_drop;
    }
    if (code >= 71 && code <= 77) {
      return Icons.ac_unit;
    }
    if (code >= 95) {
      return Icons.thunderstorm;
    }
    return Icons.cloud;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2196F3),
            Color(0xFF1565C0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  '${city.name}, ${city.country}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Icon(
            getWeatherIcon(weather.weatherCode),
            size: 90,
            color: Colors.white,
          ),

          const SizedBox(height: 12),

          Text(
            '${weather.temperature.toStringAsFixed(1)}°C',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            getWeatherDescription(weather.weatherCode),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Feels like '
                '${weather.feelsLike.toStringAsFixed(1)}°C',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
