import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, String>> favorites = [
    {
      'name': 'Akhenaton',
      'description': 'King of Egypt of the 18th dynasty',
    },
    {
      'name': 'Hatsheput',
      'description': 'Queen of Egypt, Thutmose III and the 18th Pharaoh of the 18th dynasty',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favorites[index]['name']!),
            subtitle: Text(favorites[index]['description']!),
            trailing: Icon(Icons.favorite, color: Colors.red),
          );
        },
      ),
    );
  }
}