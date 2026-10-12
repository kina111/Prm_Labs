class WeatherModel {
  final double temperature;
  final int humidity;
  final double feelsLike;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.feelsLike,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory WeatherModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final current = json['current']
    as Map<String, dynamic>;

    // ép về num trước rồi chuyển sang double
    // do api có th trả số ở dạng số nguyên hoặc số thực
    return WeatherModel(
      temperature:
      (current['temperature_2m'] as num).toDouble(),
      humidity:
      (current['relative_humidity_2m'] as num).toInt(),
      feelsLike:
      (current['apparent_temperature'] as num).toDouble(),
      precipitation:
      (current['precipitation'] as num).toDouble(),
      weatherCode:
      (current['weather_code'] as num).toInt(),
      windSpeed:
      (current['wind_speed_10m'] as num).toDouble(),
    );
  }
}
