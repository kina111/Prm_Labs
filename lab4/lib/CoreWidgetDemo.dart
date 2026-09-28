import 'package:flutter/material.dart';

class CoreWidgetDemo extends StatelessWidget {
  const CoreWidgetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exercise 1 - Core Widget Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Text(
            'Welcome to Nam flutter ui',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Icon(Icons.sticky_note_2),
          Image.network(
            'https://picsum.photos/400/200',
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movie Item'),
              subtitle: Text('This is a sample ListTile inside a Card'),
              trailing: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
    );
  }
}
