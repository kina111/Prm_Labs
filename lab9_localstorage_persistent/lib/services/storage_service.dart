// import 'dart:convert';
// import 'dart:io';
//
//
// import 'package:path_provider/path_provider.dart';
//
// import '../models/person_model.dart';
//
// class StorageService {
//   static const String fileName = 'persons.json';
//
//   // tạo đối tượng file trỏ đến file persons.json
//   Future<File> getFile() async{
//     final directory = await getApplicationDocumentsDirectory();
//     return File('${directory.path}/$fileName');
//   }
//
//   // Tạo file nếu chưa tồn tại
//   Future<File> createFileIfNotExists() async {
//     final file = await getFile();
//
//     if (!await file.exists()) {
//       await file.writeAsString('[]');
//     }
//
//     return file;
//   }
//
//   Future<List<PersonModel>> readPersons() async {
//     final file = await createFileIfNotExists();
//
//     final jsonString = await file.readAsString();
//
//     final List<dynamic> jsonData =
//     jsonDecode(jsonString) as List<dynamic>;
//
//     return jsonData.map((item) {
//       return PersonModel.fromJson(
//         item as Map<String, dynamic>,
//       );
//     }).toList();
//   }
//
//   Future<void> savePersons(List<PersonModel> persons) async {
//     final file = await createFileIfNotExists();
//
//     final jsonData = persons.map((person) {
//       return person.toJson();
//     }).toList();
//
//     final jsonString = jsonEncode(jsonData);
//
//     await file.writeAsString(jsonString);
//   }
// }



import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/person_model.dart';

class StorageService {
  static const String fileName = 'persons.json';

  Future<File> getFile() async {
    final directory =
    await getApplicationDocumentsDirectory();

    return File('${directory.path}/$fileName');
  }

  Future<File> createFileIfNotExists() async {
    final file = await getFile();

    if (!await file.exists()) {
      await file.writeAsString('[]');
    }

    return file;
  }

  Future<List<PersonModel>> readPersons() async {
    final file = await createFileIfNotExists();
    final jsonString = await file.readAsString();

    final List<dynamic> jsonData =
    jsonDecode(jsonString) as List<dynamic>;

    // Support old JSON data without IDs.
    final usedIds = <String>{};
    bool needsMigration = false;
    final persons = <PersonModel>[];

    for (final item in jsonData) {
      final json = Map<String, dynamic>.from(
        item as Map,
      );

      final id = json['id']?.toString();

      if (id == null ||
          id.isEmpty ||
          usedIds.contains(id)) {
        json['id'] = const Uuid().v4();
        needsMigration = true;
      }

      usedIds.add(json['id'] as String);
      persons.add(PersonModel.fromJson(json));
    }

    if (needsMigration) {
      await savePersons(persons);
    }

    return persons;
  }

  Future<void> savePersons(
      List<PersonModel> persons,
      ) async {
    final file = await createFileIfNotExists();

    final jsonData =
    persons.map((person) => person.toJson()).toList();

    final jsonString = const JsonEncoder.withIndent('  ')
        .convert(jsonData);

    await file.writeAsString(jsonString, flush: true);
  }
}
