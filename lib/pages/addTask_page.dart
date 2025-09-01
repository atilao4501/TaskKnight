import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _aiRecommendedTitle = "";
  String _aiRecommendedDescription = "";
  bool _isLoadingAI = false;
  bool _hasAIRecommendation = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Função de IA com Groq
  Future<void> _generateAIRecommendation() async {
    setState(() {
      _isLoadingAI = true;
    });

    try {
      // IMPORTANTE: Esta chave pode estar expirada. Gere uma nova em https://console.groq.com/keys
      const String apiKey =
          'gsk_' + 'pLeJhektMxFCvX49gnkFWGdyb3FY' + 'RSCWTmMD0yOY3ckzyRbBoDtC';
      const String apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

      // Pegando o título e descrição atuais dos campos
      String currentTitle = _titleController.text.trim();
      String currentDescription = _descriptionController.text.trim();

      // Validação básica
      if (currentTitle.isEmpty && currentDescription.isEmpty) {
        setState(() {
          _isLoadingAI = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Digite pelo menos o título ou descrição para gerar uma recomendação'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      // Criando o prompt
      String prompt =
          '''Baseado no titulo "${currentTitle.isEmpty ? 'não informado' : currentTitle}" e na descrição "${currentDescription.isEmpty ? 'não informado' : currentDescription}" da tarefa que o usuário quer adicionar, gere uma versão melhorada da tarefa. 

Retorne apenas um JSON válido no formato:
{
  "title": "título melhorado da tarefa",
  "description": "descrição detalhada e melhorada da tarefa"
}

Não inclua texto adicional, apenas o JSON.''';

      // Log da requisição para debug
      print('Fazendo requisição para: $apiUrl');
      print('Headers: Authorization: Bearer ${apiKey.substring(0, 10)}...');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
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
          cleanContent = cleanContent.substring(7); // Remove ```json
        }
        if (cleanContent.startsWith('```')) {
          cleanContent = cleanContent.substring(3); // Remove ```
        }
        if (cleanContent.endsWith('```')) {
          cleanContent = cleanContent.substring(
              0, cleanContent.length - 3); // Remove ``` final
        }
        cleanContent = cleanContent.trim();

        // Parse do JSON retornado pela IA
        final aiResponse = jsonDecode(cleanContent);

        setState(() {
          _aiRecommendedTitle = aiResponse['title'] ?? '';
          _aiRecommendedDescription = aiResponse['description'] ?? '';
          _hasAIRecommendation = true;
          _isLoadingAI = false;
        });
      } else {
        // Log detalhado do erro
        print('Erro na API - Status: ${response.statusCode}');
        print('Resposta: ${response.body}');
        throw Exception(
            'Falha na API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro detalhado: $e');

      setState(() {
        _isLoadingAI = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Função de IA não disponível no momento. Tente novamente mais tarde.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  // Salva a recomendação da IA nos campos
  void _saveAIRecommendation() {
    if (_hasAIRecommendation) {
      _titleController.text = _aiRecommendedTitle;
      _descriptionController.text = _aiRecommendedDescription;
    }
  }

  // Mock da função de salvar tarefa
  void _saveTask() {
    // Aqui você implementará a lógica de salvar a tarefa
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC19A6B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA67B5B),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Botão de voltar
                      Positioned(
                        left: 10,
                        top: 0,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 38,
                            height: 63,
                            child: Center(
                              child: Text(
                                '←',
                                style: TextStyle(
                                  fontFamily: 'VCR_OSD_MONO',
                                  fontSize: 64,
                                  color: Colors.white,
                                  height: 1.0,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      color: Colors.black,
                                    ),
                                    Shadow(
                                      offset: Offset(-1, -1),
                                      color: Colors.black,
                                    ),
                                    Shadow(
                                      offset: Offset(1, -1),
                                      color: Colors.black,
                                    ),
                                    Shadow(
                                      offset: Offset(-1, 1),
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Conteúdo principal
                      Positioned(
                        left: 10,
                        top: 200,
                        child: Container(
                          width: 333,
                          height: 502,
                          child: Column(
                            children: [
                              // Campo Title
                              Container(
                                width: 250,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      offset: const Offset(0, 4),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _titleController,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  maxLength: 35,
                                  style: const TextStyle(
                                    fontFamily: 'VCR_OSD_MONO',
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Title',
                                    hintStyle: TextStyle(
                                      fontFamily: 'VCR_OSD_MONO',
                                      fontSize: 18,
                                      color: Colors.black54,
                                    ),
                                    border: InputBorder.none,
                                    counterText: '',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    isDense: true,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Campo Description
                              Container(
                                width: 313,
                                height: 128,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      offset: const Offset(0, 4),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: TextField(
                                    controller: _descriptionController,
                                    maxLines: 6,
                                    maxLength: 200,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                      fontFamily: 'VCR_OSD_MONO',
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Describe your task here...',
                                      hintStyle: TextStyle(
                                        fontFamily: 'VCR_OSD_MONO',
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                      border: InputBorder.none,
                                      counterText: '',
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 10),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Seção AI
                              Container(
                                width: 313,
                                height: 207,
                                child: Column(
                                  children: [
                                    // Botão AI
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: GestureDetector(
                                        onTap: _isLoadingAI
                                            ? null
                                            : _generateAIRecommendation,
                                        child: Container(
                                          width: 79,
                                          height: 34,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF00796B),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                offset: const Offset(0, 4),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: _isLoadingAI
                                                ? const SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const Text(
                                                    'AI',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'VCR_OSD_MONO',
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // Bloco de recomendação da IA (scrollável)
                                    if (_hasAIRecommendation)
                                      Container(
                                        width: 313,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.25),
                                              offset: const Offset(0, 4),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Title: $_aiRecommendedTitle',
                                                style: const TextStyle(
                                                  fontFamily: 'VCR_OSD_MONO',
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Desc: $_aiRecommendedDescription',
                                                style: const TextStyle(
                                                  fontFamily: 'VCR_OSD_MONO',
                                                  fontSize: 13,
                                                  color: Colors.black54,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    // Botão Save (só aparece quando há recomendação)
                                    if (_hasAIRecommendation)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: _saveAIRecommendation,
                                            child: Container(
                                              width: 100,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF4CAF50),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Use This',
                                                  style: TextStyle(
                                                    fontFamily: 'VCR_OSD_MONO',
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 25),

                              // Botão Accept
                              GestureDetector(
                                onTap: _saveTask,
                                child: Container(
                                  width: 162,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4CAF50),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        offset: const Offset(0, 4),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Accept',
                                      style: TextStyle(
                                        fontFamily: 'VCR_OSD_MONO',
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
