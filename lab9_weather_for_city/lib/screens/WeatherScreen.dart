
import 'package:flutter/material.dart';

import '../models/CityModel.dart';
import '../models/WeatherModel.dart';
import '../services/GeocodingService.dart';
import '../services/WeatherService.dart';
import '../widgets/weather_card.dart';
import '../widgets/weather_details.dart';
import '../widgets/weather_recommendation.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() =>
      _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController cityController =
  TextEditingController();

  final GeocodingService geocodingService =
  GeocodingService();

  final WeatherService weatherService =
  WeatherService();

  List<CityModel> cities = [];
  CityModel? selectedCity;
  Future<WeatherModel>? weatherFuture;

  bool isSearching = false;
  String? searchError;

  Future<void> searchCity() async {
    final query = cityController.text.trim();

    if (query.isEmpty) return;

    setState(() {
      isSearching = true;
      searchError = null;
      cities = [];
      selectedCity = null;
      weatherFuture = null;
    });

    try {
      final result =
      await geocodingService.searchCities(query);

      if (!mounted) return;

      setState(() {
        cities = result;

        if (result.isEmpty) {
          searchError = 'No cities found';
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        searchError = 'Failed to search cities: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          isSearching = false;
        });
      }
    }
  }

  void selectCity(CityModel city) {
    setState(() {
      selectedCity = city;
      cities = [];

      weatherFuture = weatherService.fetchWeather(
        latitude: city.latitude,
        longitude: city.longitude,
      );
    });
  }

  void retryWeather() {
    final city = selectedCity;

    if (city == null) return;

    selectCity(city);
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        title: const Text('Weather Companion'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: cityController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => searchCity(),
            decoration: InputDecoration(
              hintText: 'Enter city name...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: searchCity,
              ),
              border: const OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          if (isSearching)
            const Center(
              child: CircularProgressIndicator(),
            ),

          if (searchError != null) ...[
            Text(
              searchError!,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            TextButton(
              onPressed: searchCity,
              child: const Text('Retry Search'),
            ),
          ],

          ...cities.map((city) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(city.name),
                subtitle: Text(city.country),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => selectCity(city),
              ),
            );
          }),

          if (selectedCity != null) ...[
            const SizedBox(height: 20),

            Text(
              '${selectedCity!.name}, '
                  '${selectedCity!.country}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),
          ],

          if (weatherFuture != null)
            FutureBuilder<WeatherModel>(
              future: weatherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Column(
                    children: [
                      const Text(
                        'Failed to load weather',
                      ),
                      ElevatedButton(
                        onPressed: retryWeather,
                        child: const Text('Retry'),
                      ),
                    ],
                  );
                }

                if (!snapshot.hasData) {
                  return const Text('No weather data');
                }

                final weather = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WeatherCard(
                      city: selectedCity!,
                      weather: weather,
                    ),

                    const SizedBox(height: 24),

                    WeatherDetails(
                      weather: weather,
                    ),

                    const SizedBox(height: 24),

                    WeatherRecommendation(
                      weather: weather,
                    ),

                    const SizedBox(height: 24),
                  ],
                );


              },
            ),
        ],
      ),
    );
  }
}
