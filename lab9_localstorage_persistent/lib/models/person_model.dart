// lab 9.1 & 9.2
// class PersonModel {
//   final String name;
//   final int age;
//   final bool isSingle;
//
//   PersonModel({
//     required this.name,
//     required this.age,
//     required this.isSingle,
//   });
//
//   // Convert JSON -> Dart Object
//   factory PersonModel.fromJson(Map<String, dynamic> json) {
//     return PersonModel(
//       name: json['name'] as String,
//       age: (json['age'] as num).toInt(),
//       isSingle: json['isSingle'] as bool,
//     );
//   }
//
//   // Convert Dart Object -> JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'age': age,
//       'isSingle': isSingle,
//     };
//   }
// }


// lab 9.3 them id
class PersonModel {
  final String id;
  final String name;
  final int age;
  final bool isSingle;

  PersonModel({
    required this.id,
    required this.name,
    required this.age,
    required this.isSingle,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'] as String,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      isSingle: json['isSingle'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'isSingle': isSingle,
    };
  }

  PersonModel copyWith({
    String? name,
    int? age,
    bool? isSingle,
  }) {
    return PersonModel(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      isSingle: isSingle ?? this.isSingle,
    );
  }
}
