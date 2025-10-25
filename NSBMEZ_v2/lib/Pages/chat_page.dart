import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatDialog extends StatefulWidget {
  @override
  _ChatDialogState createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  List<ChatMessage> messages = [];
  TextEditingController textController = TextEditingController();

  late final String apiKey;
  late final String apiUrl;

  @override
  void initState() {
    super.initState();

    apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
    apiUrl = dotenv.env['OPENAI_API_URL'] ?? '';

    if (apiKey.isEmpty || apiUrl.isEmpty) {
      print('Warning: OpenAI API key or URL is missing in .env!');
    }

    // Optionally fetch previous messages or start fresh
    // fetchChatMessages();
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(isMe: true, text: text));
    });
    textController.clear();

    if (apiKey.isEmpty || apiUrl.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'prompt': text,
          'max_tokens': 50,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String generatedMessage = data['choices'][0]['text'] ?? '';

        setState(() {
          messages.add(ChatMessage(isMe: false, text: generatedMessage));
        });
      } else {
        print('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Chat Popup'),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) => messages[index],
              ),
            ),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              onPressed: () => sendMessage(textController.text),
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final bool isMe;
  final String text;

  ChatMessage({required this.isMe, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
