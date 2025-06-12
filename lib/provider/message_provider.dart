import 'package:chatbot/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageProvider with ChangeNotifier {
  String _responseText = "";
  List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  String get responseText => _responseText;
  List<Map<String, dynamic>> get messages => _messages;
  bool get isTyping => _isTyping;

  Future<void> sendMessage(String message) async {
    _messages.add({
      'text': message,
      'isUser': true,
      'time': DateFormat('hh:mm a').format(DateTime.now()),
    });

    _responseText = "Thinking..";
    _isTyping = true;
    notifyListeners();

    String reply = await GooglleApiService.getApiResponse(message);

    _responseText = reply;

    _messages.add({
      'text': reply,
      'isUser': false,
      'time': DateFormat('hh:mm a').format(DateTime.now()),
    });

    _isTyping = false;
    notifyListeners();
  }
}
