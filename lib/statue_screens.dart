import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'chat.dart';

class MainBottomNavigation extends StatefulWidget {
  @override
  _MainBottomNavigationState createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    DiscoverScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, Zeyad'),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => ChatPage(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(
              hintText: 'Search...',
              leading: Icon(Icons.search),
            ),
            SizedBox(height: 16),
            Text(
              'Popular Statues',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildStatueCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatueCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/c/cf/Ramses_II_British_Museum.jpg',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey,
                  child: Center(
                    child: Text('Image not found'),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ramesses II',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Great king of the 19th dynasty',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class ChatPage extends StatefulWidget {
  static const routeName = '/chat';
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _chatHistory = [];

  void getAnswer() async {
    final url =
        "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key=AIzaSyDkeoSBCVNX1CSz1EaU0HueGUgdrsnrIQw";
    final uri = Uri.parse(url);

    List<Map<String, dynamic>> contents = [];
    for (var i = 0; i < _chatHistory.length; i++) {
      contents.add({
        "role": _chatHistory[i]["isSender"] ? "user" : "model",
        "parts": [
          {"text": _chatHistory[i]["message"]}
        ]
      });
    }

    Map<String, dynamic> request = {
      "contents": contents,
      "generationConfig": {
        "temperature": 0.25,
        "maxOutputTokens": 1000,
        "topP": 1.0,
        "topK": 1,
      }
    };

    try {
      print("Sending request to API: ${jsonEncode(request)}"); // Debug log
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Parse the response from Gemini API
        final responseBody = json.decode(response.body);
        final generatedText = responseBody["candidates"][0]["content"]["parts"][0]["text"];

        setState(() {
          _chatHistory.add({
            "time": DateTime.now(),
            "message": generatedText,
            "isSender": false,
          });
        });
      } else {

        setState(() {
          _chatHistory.add({
            "time": DateTime.now(),
            "message": "Error: Failed to get response from API (Status: ${response.statusCode})",
            "isSender": false,
          });
        });
      }
    } catch (e) {

      print("Error: $e");
      setState(() {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": "Error: $e",
          "isSender": false,
        });
      });
    }

    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 160,
            child: ListView.builder(
              itemCount: _chatHistory.length,
              shrinkWrap: false,
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                  EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (_chatHistory[index]["isSender"]
                        ? Alignment.topRight
                        : Alignment.topLeft),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color: (_chatHistory[index]["isSender"]
                            ? Color(0xFFFFC107)
                            : Colors.white),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        _chatHistory[index]["message"],
                        style: TextStyle(
                          fontSize: 15,
                          color: _chatHistory[index]["isSender"]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: GradientBoxBorder(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Type a message",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                          controller: _chatController,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        if (_chatController.text.isNotEmpty) {
                          _chatHistory.add({
                            "time": DateTime.now(),
                            "message": _chatController.text,
                            "isSender": true,
                          });
                          _chatController.clear();
                        }
                      });
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                      getAnswer();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: const EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFFC107), Color(0xFFFFFFFF)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Container(
                        constraints:
                        const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientBoxBorder extends BoxBorder {
  final Gradient gradient;

  const GradientBoxBorder({required this.gradient});

  @override
  BorderSide get bottom => BorderSide.none;

  @override
  BorderSide get top => BorderSide.none;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  bool get isUniform => true; // Fixed: Override as a getter

  @override
  void paint(
      Canvas canvas,
      Rect rect, {
        TextDirection? textDirection,
        BoxShape shape = BoxShape.rectangle,
        BorderRadius? borderRadius,
      }) {
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (shape == BoxShape.circle) {
      canvas.drawCircle(rect.center, rect.shortestSide / 2, paint);
    } else {
      // Fixed: Use a Radius value instead of toRRect
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          borderRadius?.bottomLeft ?? Radius.zero, // Use a Radius property
        ),
        paint,
      );
    }
  }

  @override
  ShapeBorder scale(double t) => this;
}

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final List<Map<String, String>> statues = [
    {
      'name': 'Akhenaton',
      'description': 'King of Egypt of the 18th dynasty',
      'image': 'assets/akhenaton.png',
    },
    {
      'name': 'Nefertiti',
      'description': 'Queen of Egypt and wife of Pharaoh Akhenaton',
      'image': 'assets/nefertiti.jpg',
    },
    {
      'name': 'Hatshepsut',
      'description': 'This granite statue portrays Queen Hatshepsut',
      'image': 'assets/hatshepsut.jpg',
    },
    {
      'name': 'Thutmose',
      'description': 'Over the course of 17 campaigns, he secured more territory than any other king',
      'image': 'assets/thutmose.jpg',
    },
  ];

  final TextEditingController _searchController = TextEditingController();


  List<Map<String, String>> _filteredStatues = [];

  @override
  void initState() {
    super.initState();
    _filteredStatues = statues;
  }


  void _filterStatues(String query) {
    setState(() {
      _filteredStatues = statues
          .where((statue) =>
      statue['name']!.toLowerCase().contains(query.toLowerCase()) ||
          statue['description']!.toLowerCase().contains(query.toLowerCase())
      )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Statues'),
        actions: [
          // إضافة زر الشات بوت هنا أيضًا
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => ChatPage(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search statues...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterStatues,
            ),
          ),

          // قائمة التماثيل
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStatues.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(_filteredStatues[index]['image']!),
                  ),
                  title: Text(_filteredStatues[index]['name']!),
                  subtitle: Text(_filteredStatues[index]['description']!),
                  trailing: Icon(Icons.info_outline),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, String>> favorites = [
    {
      'name': 'Akhenaton',
      'description': 'King of Egypt of the 18th dynasty',
      'image': 'assets/akhenaton.png', // Added image path
    },
    {
      'name': 'Hatsheput',
      'description': 'Queen of Egypt, Thutmose III and the 18th Pharaoh of the 18th dynasty',
      'image': 'assets/hatshepsut.jpg', // Added image path
    },
    {
      'name': 'Nefertiti',
      'description': 'Queen of Egypt and wife of Pharaoh Akhenaton',
      'image': 'assets/nefertiti.jpg',
    },
    {
      'name': 'Thutmose',
      'description': 'Over the course of 17 campaigns, he secured more territory than any other king',
      'image': 'assets/thutmose.jpg',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        actions: [
          // إضافة زر الشات بوت هنا أيضًا
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => ChatPage(),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(favorites[index]['image']!),
            ),
            title: Text(favorites[index]['name']!),
            subtitle: Text(favorites[index]['description']!),
            trailing: Icon(Icons.favorite, color: Colors.red),
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          // إضافة زر الشات بوت هنا أيضًا
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => ChatPage(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Zeyad'),
            subtitle: Text('zeyadmohamed@email.com'),
            leading: CircleAvatar(
              child: Text('Z'),
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
      onTap: () {
        // Add navigation or action logic
      },
    );
  }
}