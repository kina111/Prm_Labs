
import 'package:flutter/material.dart';

import '../models/WeatherModel.dart';

class WeatherDetails extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetails({
    super.key,
    required this.weather,
  });

  Widget buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 28,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weather Details',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            buildDetailCard(
              icon: Icons.water_drop,
              title: 'Humidity',
              value: '${weather.humidity}%',
            ),

            buildDetailCard(
              icon: Icons.air,
              title: 'Wind Speed',
              value:
              '${weather.windSpeed.toStringAsFixed(1)} km/h',
            ),

            buildDetailCard(
              icon: Icons.cloud,
              title: 'Precipitation',
              value:
              '${weather.precipitation.toStringAsFixed(1)} mm',
            ),

            buildDetailCard(
              icon: Icons.thermostat,
              title: 'Feels Like',
              value:
              '${weather.feelsLike.toStringAsFixed(1)}°C',
            ),
          ],
        ),
      ],
    );
  }
}
