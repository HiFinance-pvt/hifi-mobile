import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SessionService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.hifi.click/api/v1/adk',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<String?> _getAuthToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  Future<List<Map<String, dynamic>>> listSessions() async {
    try {
      final token = await _getAuthToken();
      if (token == null) throw 'Not authenticated';

      final response = await _dio.get(
        '/list-sessions',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((e) => e as Map<String, dynamic>).toList();
      }
      return [];
    } on DioException catch (e) {
      print('❌ [SessionService] Error: ${e.message}');
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> createSession() async {
    try {
      final token = await _getAuthToken();
      if (token == null) throw 'Not authenticated';

      final response = await _dio.post(
        '/create-session',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['data'] as Map<String, dynamic>;
      }
      throw 'Failed to create session';
    } on DioException catch (e) {
      print('❌ [SessionService] Create session error: ${e.message}');
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getSession(String sessionId) async {
    try {
      final token = await _getAuthToken();
      if (token == null) throw 'Not authenticated';

      final response = await _dio.get(
        '/get-session',
        queryParameters: {'session_id': sessionId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        print('📋 [SessionService] Session details: ${response.data}');
        return response.data['data'] as Map<String, dynamic>;
      }
      throw 'Failed to fetch session';
    } on DioException catch (e) {
      print('❌ [SessionService] Get session error: ${e.message}');
      throw _handleDioError(e);
    }
  }

  Future<bool> deleteSession(String sessionId) async {
    try {
      final token = await _getAuthToken();
      if (token == null) throw 'Not authenticated';

      final response = await _dio.delete(
        '/delete-session',
        queryParameters: {'session_id': sessionId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('❌ [SessionService] Delete session error: ${e.message}');
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      default:
        return 'Network error';
    }
  }
}
