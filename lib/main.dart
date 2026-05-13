import 'package:flutter/material.dart';

void main() {
  runApp(const TextMirrorApp());
}

class TextMirrorApp extends StatelessWidget {
  const TextMirrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Mirror',
      home: TextMirrorScreen(),
    );
  }
}

// STATELESS Widget - Just displays text
class MessageDisplay extends StatelessWidget {
  final String text;

  const MessageDisplay({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          text.isEmpty ? 'Start typing...' : text,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// STATEFUL Widget - Manages text input
class TextMirrorScreen extends StatefulWidget {
  @override
  State<TextMirrorScreen> createState() => _TextMirrorScreenState();
}

class _TextMirrorScreenState extends State<TextMirrorScreen> {
  String _userInput = ''; // State variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Mirror App')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // STATELESS display widget
            MessageDisplay(text: _userInput),

            const SizedBox(height: 30),

            // STATEFUL TextField - changes state when user types
            TextField(
              onChanged: (value) {
                setState(() {
                  _userInput = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Type something...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.edit),
              ),
              maxLength: 50,
            ),

            const SizedBox(height: 20),

            // STATEFUL Button - clears the text
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _userInput = '';
                });
              },
              icon: const Icon(Icons.clear),
              label: const Text('Clear Text'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
