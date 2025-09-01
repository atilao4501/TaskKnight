/// Modelo que representa uma recomendação gerada pela IA
class AiRecommendation {
  final String title;
  final String description;

  const AiRecommendation({
    required this.title,
    required this.description,
  });

  /// Cria uma instância vazia de AiRecommendation
  factory AiRecommendation.empty() {
    return const AiRecommendation(
      title: '',
      description: '',
    );
  }

  /// Verifica se a recomendação tem conteúdo válido
  bool get isValid => title.isNotEmpty || description.isNotEmpty;

  /// Cria uma cópia da recomendação com novos valores
  AiRecommendation copyWith({
    String? title,
    String? description,
  }) {
    return AiRecommendation(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'AiRecommendation(title: $title, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiRecommendation &&
        other.title == title &&
        other.description == description;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode;
}
