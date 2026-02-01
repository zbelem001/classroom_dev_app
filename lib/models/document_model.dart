class Document {
  final String id;
  final String userId;
  final String filename;
  final String originalFilename;
  final int fileSize;
  final int pageCount;
  final String processingStatus;
  final DateTime uploadedAt;
  final String mimeType;
  final List<String> tags;
  final bool isArchived;
  
  Document({
    required this.id,
    required this.userId,
    required this.filename,
    required this.originalFilename,
    required this.fileSize,
    required this.pageCount,
    required this.processingStatus,
    required this.uploadedAt,
    required this.mimeType,
    this.tags = const [],
    this.isArchived = false,
  });
  
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] ?? json['document_id'] ?? '',
      userId: json['user_id'] ?? '',
      filename: json['filename'] ?? '',
      originalFilename: json['original_filename'] ?? json['filename'] ?? '',
      fileSize: json['file_size'] ?? 0,
      pageCount: json['page_count'] ?? json['pages'] ?? 0,
      processingStatus: json['processing_status'] ?? json['status'] ?? 'unknown',
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.parse(json['uploaded_at'])
          : DateTime.now(),
      mimeType: json['mime_type'] ?? 'application/pdf',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isArchived: json['is_archived'] ?? false,
    );
  }
  
  String get fileSizeFormatted {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  
  String get statusText {
    switch (processingStatus.toLowerCase()) {
      case 'completed':
        return 'Traité';
      case 'processing':
        return 'En cours...';
      case 'failed':
        return 'Échec';
      default:
        return 'Inconnu';
    }
  }
}
