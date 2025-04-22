import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'gradient_text.dart';

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
    final url = "https://openrouter.ai/api/v1/chat/completions";
    final uri = Uri.parse(url);


    List<Map<String, dynamic>> messages = [];

    for (var i = 0; i < _chatHistory.length; i++) {
      messages.add({
        "role": _chatHistory[i]["isSender"] ? "user" : "assistant",
        "content": _chatHistory[i]["message"],
      });
    }

    if (_chatController.text.isNotEmpty) {
      messages.add({
        "role": "user",
        "content": _chatController.text,
      });
    }


    Map<String, dynamic> request = {
      "model": "deepseek/deepseek-chat-v3-0324:free",
      "messages": messages,
      "temperature": 0.25,
      "max_tokens": 1000,
    };

    try {
      print("ببعت الطلب لـ OpenRouter API: ${jsonEncode(request)}");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer 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", // الـ API Key المطلوب
        },
        body: jsonEncode(request),
      );

      print("حالة الرد: ${response.statusCode}");
      print("الرد: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final generatedText = responseBody["choices"][0]["message"]["content"];

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
            "message":
            "خطأ: فشلت في جلب الرد من الـ API (الحالة: ${response.statusCode})",
            "isSender": false,
          });
        });
      }
    } catch (e) {
      print("خطأ: $e");
      setState(() {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": "خطأ: $e",
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
        title: Text(
          "Chat",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Match onboarding title color
          ),
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
                  const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
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
                            ? Colors.amber // Cyan for sender bubble
                            : Colors.white), // White for receiver bubble
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _chatHistory[index]["message"],
                        style: TextStyle(
                          fontSize: 15,
                          color: _chatHistory[index]["isSender"]
                              ? Colors.white // White on cyan
                              : Colors.black, // Black on white
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
                            colors: [
                              Colors.amber, // Cyan gradient start
                              Colors.amber, // Cyan gradient end
                            ],
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
                          colors: [
                            Colors.amber, // Cyan gradient start
                            Colors.amber, // Cyan gradient end
                          ],
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
  bool get isUniform => true;

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
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          borderRadius?.bottomLeft ?? Radius.zero,
        ),
        paint,
      );
    }
  }

  @override
  ShapeBorder scale(double t) => this;
}