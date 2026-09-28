import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  static const List<String> items = [
    'Avatar',
    'Inception',
    'Interstella',
    'Joker',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3: Layout Polish'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'NOW PLAYING',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ListView chiếm phần không gian còn lại
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: Text(items[index]),
                    subtitle: const Text('Sample description'),
                    trailing: const Icon(Icons.details),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}