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
