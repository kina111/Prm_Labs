
class CityModel {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  CityModel({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory CityModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CityModel(
      name: json['name'] as String,
      country: json['country'] as String? ?? '',
      latitude:
      (json['latitude'] as num).toDouble(),
      longitude:
      (json['longitude'] as num).toDouble(),
    );
  }
}
