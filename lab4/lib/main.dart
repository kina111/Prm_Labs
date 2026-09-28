import 'package:flutter/material.dart';
import 'package:lab4/InputControlsDemo.dart';
import 'CoreWidgetDemo.dart';
import 'InputControlsDemo.dart';
import 'HomeScreen.dart';
import 'CommonLayoutFixesScreen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      // home: const CoreWidgetDemo(),
      // home: const InputControlsDemo(),
      //   home: const Homescreen(),
      home: const CommonLayoutFixesScreen(),
    );
  }
}

// exe 4
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   // false = Light Mode
//   // true = Dark Mode
//   bool isDarkMode = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//
//       // Theme cho Light Mode
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.blue,
//           brightness: Brightness.light,
//         ),
//         useMaterial3: true,
//       ),
//
//       // Theme cho Dark Mode
//       darkTheme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.blue,
//           brightness: Brightness.dark,
//         ),
//         useMaterial3: true,
//       ),
//
//       // Chọn theme dựa vào biến isDarkMode
//       themeMode: isDarkMode
//           ? ThemeMode.dark
//           : ThemeMode.light,
//
//       home: Exe4(
//         isDarkMode: isDarkMode,
//
//         // Callback để thay đổi Dark Mode
//         onThemeChanged: (value) {
//           setState(() {
//             isDarkMode = value;
//           });
//         },
//       ),
//     );
//   }
// }
//
// class Exe4 extends StatelessWidget {
//   final bool isDarkMode;
//   final ValueChanged<bool> onThemeChanged;
//
//   const Exe4({
//     super.key,
//     required this.isDarkMode,
//     required this.onThemeChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dark Mode Example'),
//       ),
//
//       body: Center(
//         child: SwitchListTile(
//           title: const Text('Dark Mode'),
//           subtitle: Text(
//             isDarkMode ? 'Dark Mode đang bật' : 'Dark Mode đang tắt',
//           ),
//           value: isDarkMode,
//
//           // Khi Switch thay đổi
//           onChanged: onThemeChanged,
//         ),
//       ),
//
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
