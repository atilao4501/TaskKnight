import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_recommendation.dart';

class GroqAiService {
  static const String _apiKey =
      'gsk_' + 'pLeJhektMxFCvX49gnkFWGdyb3FY' + 'RSCWTmMD0yOY3ckzyRbBoDtC';
  static const String _apiUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  /// Gera uma recomendação de tarefa usando IA baseada no título e descrição fornecidos
  static Future<AiRecommendation> generateRecommendation({
    required String title,
    required String description,
  }) async {
    // Validação de entrada
    if (title.trim().isEmpty && description.trim().isEmpty) {
      throw ArgumentError(
          'Digite pelo menos o título ou descrição para gerar uma recomendação');
    }

    // Criando o prompt
    final prompt =
        '''Baseado no titulo "${title.isEmpty ? 'não informado' : title}" e na descrição "${description.isEmpty ? 'não informado' : description}" da tarefa que o usuário quer adicionar, gere uma versão melhorada da tarefa. 

Retorne apenas um JSON válido no formato:
{
  "title": "título melhorado da tarefa",
  "description": "descrição detalhada e melhorada da tarefa"
}

Não inclua texto adicional, apenas o JSON.''';

    // Log da requisição para debug
    print('Fazendo requisição para: $_apiUrl');
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
        // Log detalhado do erro
        print('Erro na API - Status: ${response.statusCode}');
        print('Resposta: ${response.body}');
        throw Exception(
            'Falha na API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro detalhado: $e');
      rethrow;
    }
  }
}
