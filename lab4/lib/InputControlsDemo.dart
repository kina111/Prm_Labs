import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double volume = 50;
  bool isOn = false;
  String genre = 'Action';
  DateTime selectedDate = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2: Input Controls Demo'),
      ),
      body: Column(
        children: [
          Slider(
            value: volume,
            min: 0,
            max: 100,
            divisions: 5,
            label: 'Rating (slider)',
            onChanged: (value) {
              setState(() {
                volume = value;
              });
            },
          ),
          Text(
            'Current value: $volume'
          ),
          Switch(
            value: isOn,
            onChanged: (value) {
              setState(() {
                isOn = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Action'),
            value: 'Action',
            groupValue: genre,
            onChanged: (value) {
              setState(() {
                genre = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Comedy'),
            value: 'Comedy',
            groupValue: genre,
            onChanged: (value) {
              setState(() {
                genre = value!;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.open_in_full),
            onPressed: () {
              showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                initialDate: selectedDate,
              ).then((onValue) {
                setState(() {
                  selectedDate = onValue!;
                });
              });
            },
          ),
          Text('Selected Date: ${selectedDate}')
        ],
      ),
    );
  }
}
