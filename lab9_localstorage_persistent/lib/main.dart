
// LAB 9.1 ======================================================================
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         colorScheme: .fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   late Future<List<dynamic>> _persons;
//
//   @override
//   void initState(){
//     super.initState();
//     _persons = loadPersons();
//   }
//
//   Future<List<dynamic>> loadPersons() async{
//     final loadString = await rootBundle.loadString('assets/data/persons.json');
//     return jsonDecode(loadString) as List<dynamic>;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Persons')),
//       body: FutureBuilder<List<dynamic>>(
//         future: _persons,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//
//           final persons = snapshot.data ?? [];
//
//           return ListView.builder(
//             itemCount: persons.length,
//             itemBuilder: (context, index) {
//               final person = persons[index];
//
//               return ListTile(
//                 title: Text(person['name']),
//                 subtitle: Text('Age: ${person['age']}'),
//                 trailing: Icon(
//                   person['isSingle']
//                       ? Icons.person
//                       : Icons.favorite,
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// LAB 9.2 ======================================================================

// import 'package:flutter/material.dart';
//
// import 'screens/person_screen.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Person Manager',
//       theme: ThemeData(
//         colorSchemeSeed: Colors.blue,
//         useMaterial3: true,
//       ),
//       home: const PersonScreen(),
//     );
//   }
// }


// lab 9.3 =====================================================================

import 'package:flutter/material.dart';

import 'screens/person_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JSON CRUD Mini Database',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const PersonScreen(),
    );
  }
}
