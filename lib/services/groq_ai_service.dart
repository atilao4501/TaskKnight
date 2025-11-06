import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_recommendation.dart';

class GroqAiService {
  /// Indicates if the Groq service was reachable on last check.
  static bool isAvailable = true;
  static const String _apiKey =
      'gsk_' + 'pLeJhektMxFCvX49gnkFWGdyb3FY' + 'RSCWTmMD0yOY3ckzyRbBoDtC';
  static const String _apiUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  /// Generate a task recommendation using AI based on the provided title and description
  static Future<AiRecommendation> generateRecommendation({
    required String title,
    required String description,
  }) async {
    // Validação de entrada
    if (title.trim().isEmpty && description.trim().isEmpty) {
      throw ArgumentError(
          'Please provide at least a title or description to generate a recommendation');
    }

    // Criando o prompt
    final prompt =
        '''Based on the task title "${title.isEmpty ? 'not provided' : title}" and description "${description.isEmpty ? 'not provided' : description}", generate an improved and clearer version of the task in English. Follow principles from Cognitive Behavioral Therapy (CBT) where appropriate.

Your goal is to make the task specific, actionable, and achievable so the user is more likely to complete it. The reformulation should:
- Make the title short and action-oriented.
- Make the description detailed, including when, where and how the task can be done.
- Break down broad actions into a single concrete task (e.g., instead of "go to the gym", write "do a 30-minute leg workout at the gym today").
- Avoid multiple actions in the same task.

Return only a valid JSON object with the following keys:
{
  "title": "improved task title",
  "description": "detailed and improved task description"
}

Do not include any extra text, only the JSON.''';

    // Request log for debugging
    print('Making request to: $_apiUrl');
    print('Headers: Authorization: Bearer ${_apiKey.substring(0, 10)}...');

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'model': 'meta-llama/llama-4-scout-17b-16e-instruct',
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final content = responseData['choices'][0]['message']['content'];

        // Remove markdown code blocks se existirem
        String cleanContent = content.trim();
        if (cleanContent.startsWith('```json')) {
          cleanContent = cleanContent.substring(7);
        }
        if (cleanContent.startsWith('```')) {
          cleanContent = cleanContent.substring(3);
        }
        if (cleanContent.endsWith('```')) {
          cleanContent = cleanContent.substring(0, cleanContent.length - 3);
        }
        cleanContent = cleanContent.trim();

        // Parse do JSON retornado pela IA
        final aiResponse = jsonDecode(cleanContent);

        return AiRecommendation(
          title: aiResponse['title'] ?? '',
          description: aiResponse['description'] ?? '',
        );
      } else {
        // Detailed error log
        print('API error - Status: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception(
            'API failure: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Detailed error: $e');
      rethrow;
    }
  }

  /// Performs a lightweight test request to check if the Groq API is reachable.
  /// Sets [isAvailable] to true when a 200 response is received, otherwise false.
  /// This method is safe to call at app startup and will timeout after 5 seconds.
  static Future<void> initialize() async {
    try {
      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {
              'Authorization': 'Bearer $_apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              // Minimal harmless prompt for availability check
              'messages': [
                {
                  'role': 'user',
                  'content':
                      'Ping: please respond with a short ok in JSON {"ok":true}',
                }
              ],
              'model': 'meta-llama/llama-4-scout-17b-16e-instruct',
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        isAvailable = true;
        print('Groq AI: service reachable');
      } else {
        isAvailable = false;
        print('Groq AI: unreachable, status ${response.statusCode}');
      }
    } catch (e) {
      isAvailable = false;
      print('Groq AI availability check failed: $e');
    }
  }
}
