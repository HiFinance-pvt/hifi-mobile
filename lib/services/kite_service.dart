import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KiteService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://api.hifi.click/api/v1",
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<String?> _getAuthToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  Future<Map<String, dynamic>> connect() async {
    try {
      final token = await _getAuthToken();
      if (token == null) throw 'Not authenticated';

      print('🔵 [KiteService] Calling: ${_dio.options.baseUrl}/kite/connect');
      print('🔵 [KiteService] Headers: Authorization: Bearer ${token.substring(0, 20)}...');
      
      final response = await _dio.get(
        '/kite/connect',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('✅ [KiteService] Connect response status: ${response.statusCode}');
      print('✅ [KiteService] Connect response data: ${response.data}');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw 'Failed to connect to Kite';
    } on DioException catch (e) {
      print('❌ [KiteService] Connect error: ${e.message}');
      print('❌ [KiteService] Connect response: ${e.response?.data}');
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getStatus() async {
    try {
      final token = await _getAuthToken();
      if (token == null) throw 'Not authenticated';

      print('🔵 [KiteService] Calling: ${_dio.options.baseUrl}/kite/status');
      print('🔵 [KiteService] Headers: Authorization: Bearer ${token.substring(0, 20)}...');
      
      final response = await _dio.get(
        '/kite/status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('✅ [KiteService] Status response status: ${response.statusCode}');
      print('✅ [KiteService] Status response data: ${response.data}');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw 'Failed to get Kite status';
    } on DioException catch (e) {
      print('❌ [KiteService] Status error: ${e.message}');
      print('❌ [KiteService] Status response: ${e.response?.data}');
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> disconnect() async {
    try {
      final token = await _getAuthToken();
      if (token == null) throw 'Not authenticated';

      print('🔵 [KiteService] Calling: ${_dio.options.baseUrl}/kite/disconnect');
      print('🔵 [KiteService] Headers: Authorization: Bearer ${token.substring(0, 20)}...');
      print('🔵 [KiteService] Body: {}');
      
      final response = await _dio.post(
        '/kite/disconnect',
        data: {},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('✅ [KiteService] Disconnect response status: ${response.statusCode}');
      print('✅ [KiteService] Disconnect response data: ${response.data}');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw 'Failed to disconnect from Kite';
    } on DioException catch (e) {
      print('❌ [KiteService] Disconnect error: ${e.message}');
      print('❌ [KiteService] Disconnect response: ${e.response?.data}');
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