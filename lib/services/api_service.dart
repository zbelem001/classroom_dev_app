import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/document_model.dart';
import '../models/summary_model.dart';

class ApiService {
  static const String baseUrl = 'https://k2mar-docuresume-backend.hf.space';
  
  // Get Headers
  Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
  
  // ==================== AUTHENTICATION ====================
  
  /// Register new user
  Future<ApiResponse<User>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data);
        await _saveUser(user);
        return ApiResponse.success(user);
      } else {
        final error = jsonDecode(response.body);
        return ApiResponse.error(error['detail'] ?? 'Registration failed');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Login user
  Future<ApiResponse<User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data);
        await _saveUser(user);
        return ApiResponse.success(user);
      } else {
        final error = jsonDecode(response.body);
        return ApiResponse.error(error['detail'] ?? 'Login failed');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Save user to local storage
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.userId);
    await prefs.setString('email', user.email);
    await prefs.setString('username', user.username);
  }
  
  /// Get current user from local storage
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId == null) return null;
    
    return User(
      userId: userId,
      email: prefs.getString('email') ?? '',
      username: prefs.getString('username') ?? '',
    );
  }
  
  /// Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  // ==================== DOCUMENTS ====================
  
  /// Upload document
  Future<ApiResponse<Document>> uploadDocument({
    required String userId,
    required String filePath,
    List<String> tags = const [],
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/documents/upload'),
      );
      
      request.fields['user_id'] = userId;
      request.fields['tags'] = jsonEncode(tags);
      
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final document = Document.fromJson(data);
        return ApiResponse.success(document);
      } else {
        final error = jsonDecode(response.body);
        return ApiResponse.error(error['detail'] ?? 'Upload failed');
      }
    } catch (e) {
      return ApiResponse.error('Upload error: $e');
    }
  }
  
  /// Get user documents
  Future<ApiResponse<List<Document>>> getUserDocuments({
    required String userId,
    int limit = 100,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/documents/user/$userId?limit=$limit'),
        headers: await _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final documents = (data['documents'] as List)
            .map((doc) => Document.fromJson(doc))
            .toList();
        return ApiResponse.success(documents);
      } else {
        return ApiResponse.error('Failed to fetch documents');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Get document content
  Future<ApiResponse<String>> getDocumentContent(String documentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/documents/$documentId/content'),
        headers: await _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.success(data['content']);
      } else {
        return ApiResponse.error('Failed to fetch content');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Delete document
  Future<ApiResponse<void>> deleteDocument(String documentId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/documents/$documentId'),
        headers: await _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error('Failed to delete document');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // ==================== SUMMARIES (GEMINI) ====================
  
  /// Generate summary with Gemini
  Future<ApiResponse<String>> generateSummaryGemini({
    required String documentId,
    int maxLength = 150,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/generate/summary/gemini?document_id=$documentId&max_length=$maxLength'),
        headers: await _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.success(data['summary']);
      } else {
        final error = jsonDecode(response.body);
        return ApiResponse.error(error['detail'] ?? 'Summary generation failed');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Query document with Gemini (Q&A)
  Future<ApiResponse<String>> queryDocumentGemini({
    required String documentId,
    required String question,
    bool useContext = true,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/query/gemini?document_id=$documentId&question=${Uri.encodeComponent(question)}&use_context=$useContext'),
        headers: await _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.success(data['answer']);
      } else {
        final error = jsonDecode(response.body);
        return ApiResponse.error(error['detail'] ?? 'Query failed');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // ==================== SEMANTIC SEARCH (FAISS) ====================
  
  /// Semantic search in document
  Future<ApiResponse<List<SearchResult>>> semanticSearch({
    required String documentId,
    required String query,
    int k = 5,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search/semantic?document_id=$documentId&query=${Uri.encodeComponent(query)}&k=$k'),
        headers: await _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = (data['results'] as List)
            .map((r) => SearchResult.fromJson(r))
            .toList();
        return ApiResponse.success(results);
      } else {
        return ApiResponse.error('Search failed');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // ==================== ANALYTICS ====================
  
  /// Get user analytics
  Future<ApiResponse<Map<String, dynamic>>> getUserAnalytics(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/analytics/user/$userId'),
        headers: await _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.success(data['analytics']);
      } else {
        return ApiResponse.error('Failed to fetch analytics');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // ==================== HEALTH CHECK ====================
  
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

// ==================== API RESPONSE ====================

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  
  ApiResponse.success(this.data)
      : success = true,
        error = null;
  
  ApiResponse.error(this.error)
      : success = false,
        data = null;
}

// ==================== SEARCH RESULT ====================

class SearchResult {
  final String text;
  final double score;
  final int chunkId;
  
  SearchResult({
    required this.text,
    required this.score,
    required this.chunkId,
  });
  
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      text: json['text'],
      score: json['score'].toDouble(),
      chunkId: json['chunk_id'],
    );
  }
}
