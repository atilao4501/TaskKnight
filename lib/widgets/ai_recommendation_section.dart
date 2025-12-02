import 'package:flutter/material.dart';
import '../models/ai_recommendation.dart';

class AiRecommendationSection extends StatelessWidget {
  final bool isLoading;
  final AiRecommendation? recommendation;
  final VoidCallback onGenerateRecommendation;
  final VoidCallback onUseRecommendation;
  final bool aiEnabled;

  const AiRecommendationSection({
    super.key,
    required this.isLoading,
    this.recommendation,
    required this.onGenerateRecommendation,
    required this.onUseRecommendation,
    this.aiEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 313,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botão AI
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap:
                  (isLoading || !aiEnabled) ? null : onGenerateRecommendation,
              child: Container(
                width: 79,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFF00796B),
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
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'AI',
                          style: TextStyle(
                            fontFamily: 'VCR_OSD_MONO',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Message when AI is disabled/unavailable
          if (!aiEnabled)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 260,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Text(
                  'AI is unavailable — you may be offline or the Groq service could not be reached.',
                  style: TextStyle(
                    fontFamily: 'VCR_OSD_MONO',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 10),

          // Bloco de recomendação da IA (scrollável)
          if (recommendation != null && recommendation!.isValid)
            Container(
              width: 313,
              height: 120,
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
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Title: ${recommendation!.title}',
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
                      'Desc: ${recommendation!.description}',
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
          if (recommendation != null && recommendation!.isValid)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: onUseRecommendation,
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(5),
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
    );
  }
}
