import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/document_model.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final Document document;

  const ChatScreen({Key? key, required this.document}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _apiService = ApiService();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isGeneratingSummary = false;
  String? _summary;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: 'Bonjour! Je suis votre assistant IA. Posez-moi des questions sur "${widget.document.originalFilename}" ou demandez-moi de générer un résumé.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  Future<void> _generateSummary() async {
    setState(() {
      _isGeneratingSummary = true;
      _messages.add(ChatMessage(
        text: 'Génération du résumé en cours...',
        isUser: false,
        timestamp: DateTime.now(),
        isLoading: true,
      ));
    });

    _scrollToBottom();

    final response = await _apiService.generateSummaryGemini(
      documentId: widget.document.id,
      maxLength: 150,
    );

    setState(() {
      _isGeneratingSummary = false;
      // Remove loading message
      _messages.removeLast();

      if (response.success && response.data != null) {
        _summary = response.data!;
        _messages.add(ChatMessage(
          text: '📄 **Résumé du document:**\n\n${response.data!}',
          isUser: false,
          timestamp: DateTime.now(),
          isSummary: true,
        ));
      } else {
        _messages.add(ChatMessage(
          text: '❌ Erreur: ${response.error ?? "Impossible de générer le résumé"}',
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ));
      }
    });

    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Add loading indicator
    setState(() {
      _messages.add(ChatMessage(
        text: 'Recherche de la réponse...',
        isUser: false,
        timestamp: DateTime.now(),
        isLoading: true,
      ));
    });

    final response = await _apiService.queryDocumentGemini(
      documentId: widget.document.id,
      question: text,
      useContext: true,
    );

    setState(() {
      _isLoading = false;
      // Remove loading message
      _messages.removeLast();

      if (response.success && response.data != null) {
        _messages.add(ChatMessage(
          text: response.data!,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      } else {
        _messages.add(ChatMessage(
          text: '❌ ${response.error ?? "Erreur lors de la recherche"}',
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ));
      }
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.document.originalFilename,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${widget.document.pageCount} pages • ${widget.document.fileSizeFormatted}',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.summarize, color: AppColors.primary),
            onPressed: _isGeneratingSummary ? null : _generateSummary,
            tooltip: 'Générer un résumé',
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Input Field
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Posez une question...',
                      hintStyle: TextStyle(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingM,
                        vertical: AppDimensions.paddingM,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingS),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              radius: 16,
              child: Icon(
                Icons.smart_toy,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingS),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppColors.primary
                    : message.isError
                        ? AppColors.error.withOpacity(0.1)
                        : message.isSummary
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: message.isSummary
                    ? Border.all(color: AppColors.success.withOpacity(0.3))
                    : null,
              ),
              child: message.isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SpinKitThreeBounce(
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          message.text,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      message.text,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: message.isUser
                            ? Colors.white
                            : message.isError
                                ? AppColors.error
                                : AppColors.textPrimary,
                      ),
                    ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: AppDimensions.paddingS),
            CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              radius: 16,
              child: Icon(
                Icons.person,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;
  final bool isError;
  final bool isSummary;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
    this.isError = false,
    this.isSummary = false,
  });
}
