// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:chatbot/constants/api_endpoints.dart';
import 'package:http/http.dart' as http;

class GooglleApiService {
  static String apiKey = ApiEndpoints.apiKey;
  static String baseUrl = ApiEndpoints.baseUrl;

  static Future<String> getApiResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl$apiKey"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": message}
              ]
            }
          ]
        }),
      );

      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey("candidates") && data["candidates"].isNotEmpty) {
          var firstCandidate = data["candidates"][0];

          if (firstCandidate.containsKey("content") &&
              firstCandidate["content"].containsKey("parts") &&
              firstCandidate["content"]["parts"].isNotEmpty) {
            return firstCandidate["content"]["parts"][0]["text"] ??
                "AI response was empty.";
          }
        }
        return "AI did not return any content.";
      } else {
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      print("Error=> $e");
      return "Error: $e";
    }
  }
}
