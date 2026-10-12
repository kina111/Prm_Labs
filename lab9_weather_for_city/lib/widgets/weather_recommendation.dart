
import 'package:flutter/material.dart';

import '../models/WeatherModel.dart';
import '../services/recommendation_service.dart';

class WeatherRecommendation extends StatelessWidget {
  final WeatherModel weather;

  WeatherRecommendation({
    super.key,
    required this.weather,
  });

  final RecommendationService recommendationService =
  RecommendationService();

  Widget buildAdviceCard({
    required IconData icon,
    required String title,
    required String description,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 28,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
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
          'Weather Recommendations',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        buildAdviceCard(
          icon: Icons.umbrella,
          title: 'Umbrella Advice',
          description:
          recommendationService.getUmbrellaAdvice(weather),
          backgroundColor: const Color(0xFFEFF6FF),
          iconColor: Colors.blue,
        ),

        const SizedBox(height: 12),

        buildAdviceCard(
          icon: Icons.wb_sunny,
          title: 'Outdoor Activities',
          description:
          recommendationService.getOutdoorAdvice(weather),
          backgroundColor: const Color(0xFFFFF7ED),
          iconColor: Colors.deepOrange,
        ),

        const SizedBox(height: 12),

        buildAdviceCard(
          icon: Icons.directions_walk,
          title: 'Walking Advice',
          description:
          recommendationService.getWalkingAdvice(weather),
          backgroundColor: const Color(0xFFF0FDF4),
          iconColor: Colors.green,
        ),
      ],
    );
  }
}
