import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  final List<Map<String, String>> statues = [
    {
      'name': 'Akhenaton',
      'description': 'King of Egypt of the 18th dynasty',
      'image': 'https://example.com/akhenaton.jpg',
    },
    {
      'name': 'Nefertiti',
      'description': 'Queen of Egypt and wife of Pharaoh Akhenaton',
      'image': 'https://example.com/nefertiti.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Statues'),
      ),
      body: ListView.builder(
        itemCount: statues.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(statues[index]['image']!),
            ),
            title: Text(statues[index]['name']!),
            subtitle: Text(statues[index]['description']!),
            trailing: Icon(Icons.info_outline),
          );
        },
      ),
    );
  }
}