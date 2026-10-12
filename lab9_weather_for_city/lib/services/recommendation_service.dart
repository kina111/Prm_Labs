

import '../models/WeatherModel.dart';

class RecommendationService {
  bool isRainy(int code) {
    return (code >= 51 && code <= 67) ||
        (code >= 80 && code <= 82) ||
        (code >= 95 && code <= 99);
  }

  String getUmbrellaAdvice(WeatherModel weather) {
    if (weather.precipitation > 0 ||
        isRainy(weather.weatherCode)) {
      return 'Take an umbrella. It is raining outside.';
    }

    return 'No rain detected right now. '
        'An umbrella may not be necessary.';
  }

  String getOutdoorAdvice(WeatherModel weather) {
    if (weather.weatherCode >= 95) {
      return 'Thunderstorm conditions. '
          'Avoid outdoor activities.';
    }

    if (weather.feelsLike >= 35) {
      return 'It is very hot outside. '
          'Avoid intense outdoor exercise.';
    }

    if (weather.windSpeed >= 40) {
      return 'Strong winds detected. '
          'Be careful with outdoor activities.';
    }

    if (weather.precipitation > 0 ||
        isRainy(weather.weatherCode)) {
      return 'Rainy conditions. '
          'Consider indoor activities.';
    }

    return 'Weather conditions appear suitable '
        'for outdoor activities.';
  }

  String getWalkingAdvice(WeatherModel weather) {
    if (weather.weatherCode >= 95) {
      return 'Avoid walking outside during thunderstorms.';
    }

    if (weather.precipitation > 0 ||
        isRainy(weather.weatherCode)) {
      return 'It is raining. '
          'Consider walking indoors.';
    }

    if (weather.windSpeed >= 40) {
      return 'Strong winds may make walking uncomfortable.';
    }

    if (weather.feelsLike >= 35) {
      return 'It is too hot for a long walk. '
          'Choose cooler hours.';
    }

    if (weather.temperature < 15) {
      return 'It is cold outside. '
          'Wear warm clothes before walking.';
    }

    if (weather.temperature >= 18 &&
        weather.temperature <= 30) {
      return 'Nice weather for a walk!';
    }

    return 'You can take a short walk, '
        'but dress for the temperature.';
  }
}
