import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/user_model.dart';
import '../models/document_model.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';
import '../widgets/document_card.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _apiService = ApiService();
  List<Document> _documents = [];
  bool _isLoading = false;
  bool _isUploading = false;
  String? _uploadProgress;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() => _isLoading = true);

    final response = await _apiService.getUserDocuments(
      userId: widget.user.userId,
    );

    if (response.success && response.data != null) {
      setState(() {
        _documents = response.data!;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      _showError(response.error ?? 'Erreur de chargement');
    }
  }

  Future<void> _pickAndUploadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _isUploading = true;
          _uploadProgress = 'Upload en cours...';
        });

        final filePath = result.files.single.path!;
        final response = await _apiService.uploadDocument(
          userId: widget.user.userId,
          filePath: filePath,
        );

        if (response.success && response.data != null) {
          setState(() {
            _uploadProgress = 'Traitement OCR...';
          });

          // Wait a bit for OCR processing
          await Future.delayed(const Duration(seconds: 2));

          // Reload documents
          await _loadDocuments();

          if (mounted) {
            _showSuccess('Document uploadé avec succès!');
          }
        } else {
          _showError(response.error ?? 'Erreur d\'upload');
        }
      }
    } catch (e) {
      _showError('Erreur: $e');
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = null;
      });
    }
  }

  Future<void> _deleteDocument(Document document) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Supprimer "${document.originalFilename}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final response = await _apiService.deleteDocument(document.id);
      if (response.success) {
        _loadDocuments();
        _showSuccess('Document supprimé');
      } else {
        _showError(response.error ?? 'Erreur de suppression');
      }
    }
  }

  Future<void> _logout() async {
    await _apiService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DocuResume Pro',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Bonjour, ${widget.user.username}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
            onPressed: _logout,
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: AppColors.primary,
                size: 50,
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadDocuments,
              color: AppColors.primary,
              child: _documents.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppDimensions.paddingM),
                      itemCount: _documents.length,
                      itemBuilder: (context, index) {
                        final document = _documents[index];
                        return DocumentCard(
                          document: document,
                          onTap: () => _navigateToChat(document),
                          onDelete: () => _deleteDocument(document),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isUploading ? null : _pickAndUploadFile,
        backgroundColor: _isUploading ? AppColors.textTertiary : AppColors.primary,
        icon: _isUploading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.cloud_upload),
        label: Text(_uploadProgress ?? 'Importer PDF'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 120,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppDimensions.paddingL),
            Text(
              'Aucun document',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              'Importez votre premier document PDF pour commencer',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            ElevatedButton.icon(
              onPressed: _pickAndUploadFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                  vertical: AppDimensions.paddingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Importer un PDF'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChat(Document document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(document: document),
      ),
    );
  }
}
