import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({required this.message});

  String _processMessageText(String text) {
    if (text.isEmpty) return '';

    try {
      // Handle emojis and special characters
      final decodedText = utf8.decode(text.runes.toList(), allowMalformed: true);
      return decodedText
          .replaceAll(r'\u', '\\u') // Ensure proper emoji encoding
          .replaceAll(r'\\n', '\n'); // Handle line breaks
    } catch (e) {
      debugPrint('Message processing error: $e');
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment:
        message.isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            message.isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: message.isSent
                          ? const Color(0xFF2C2C2E)
                          : const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: message.isSent
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                        bottomLeft: !message.isSent
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      _processMessageText(message.text),
                      style: TextStyle(
                        color: message.isSent ? Colors.white : Colors.grey[300],
                        fontSize: 16,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}