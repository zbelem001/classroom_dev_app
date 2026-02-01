class Summary {
  final String id;
  final String documentId;
  final String content;
  final String summaryType;
  final String summaryLevel;
  final String modelName;
  final DateTime createdAt;
  final double? compressionRatio;
  
  Summary({
    required this.id,
    required this.documentId,
    required this.content,
    required this.summaryType,
    required this.summaryLevel,
    required this.modelName,
    required this.createdAt,
    this.compressionRatio,
  });
  
  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      id: json['id'] ?? '',
      documentId: json['document_id'] ?? '',
      content: json['content'] ?? '',
      summaryType: json['summary_type'] ?? 'abstractive',
      summaryLevel: json['summary_level'] ?? 'medium',
      modelName: json['model_name'] ?? 'Gemini',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      compressionRatio: json['compression_ratio']?.toDouble(),
    );
  }
}
