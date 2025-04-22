import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Abdelrahman'),
            subtitle: Text('abdelrahman404@email.com'),
            leading: CircleAvatar(
              child: Text('A'),
            ),
          ),
          Divider(),
          _buildProfileOption('Personal Information', Icons.person),
          _buildProfileOption('FAQ', Icons.help_outline),
          _buildProfileOption('About', Icons.info_outline),
          Spacer(),
          _buildProfileOption('Logout', Icons.logout, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon, {Color? color}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      leading: Icon(icon, color: color),
      trailing: Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}