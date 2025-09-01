import 'package:flutter/material.dart';
import '../services/groq_ai_service.dart';
import '../models/ai_recommendation.dart';
import '../widgets/title_input_field.dart';
import '../widgets/description_input_field.dart';
import '../widgets/ai_recommendation_section.dart';
import '../widgets/custom_back_button.dart' as custom;
import '../widgets/accept_button.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  AiRecommendation? _aiRecommendation;
  bool _isLoadingAI = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Função de IA usando o service
  Future<void> _generateAIRecommendation() async {
    setState(() {
      _isLoadingAI = true;
    });

    try {
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

      final recommendation = await GroqAiService.generateRecommendation(
        title: currentTitle,
        description: currentDescription,
      );

      setState(() {
        _aiRecommendation = recommendation;
        _isLoadingAI = false;
      });
    } catch (e) {
      print('Erro detalhado: $e');

      setState(() {
        _isLoadingAI = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: e is ArgumentError
                ? Text(e.message)
                : const Text(
                    'Função de IA não disponível no momento. Tente novamente mais tarde.'),
            backgroundColor: e is ArgumentError ? Colors.orange : Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  // Salva a recomendação da IA nos campos
  void _saveAIRecommendation() {
    if (_aiRecommendation != null && _aiRecommendation!.isValid) {
      _titleController.text = _aiRecommendation!.title;
      _descriptionController.text = _aiRecommendation!.description;
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
                      custom.BackButton(
                        onPressed: () => Navigator.pop(context),
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
                              TitleInputField(
                                controller: _titleController,
                              ),

                              const SizedBox(height: 8),

                              // Campo Description
                              DescriptionInputField(
                                controller: _descriptionController,
                              ),

                              const SizedBox(height: 8),

                              // Seção AI
                              AiRecommendationSection(
                                isLoading: _isLoadingAI,
                                recommendation: _aiRecommendation,
                                onGenerateRecommendation:
                                    _generateAIRecommendation,
                                onUseRecommendation: _saveAIRecommendation,
                              ),

                              const SizedBox(height: 25),

                              // Botão Accept
                              AcceptButton(
                                onPressed: _saveTask,
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
