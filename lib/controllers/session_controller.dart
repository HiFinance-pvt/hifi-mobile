import 'package:get/get.dart';
import 'package:hifi/services/session_service.dart';

class SessionController extends GetxController {
  final SessionService _sessionService = SessionService();
  
  final sessions = <Map<String, dynamic>>[].obs;
  final filteredSessions = <Map<String, dynamic>>[].obs;
  final activeSessionId = Rxn<String>();
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final needsRefresh = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSessions();
  }

  Future<Map<String, dynamic>> getSessionDetails(String sessionId) async {
    return await _sessionService.getSession(sessionId);
  }

  Future<void> fetchSessions() async {
    try {
      isLoading.value = true;
      final data = await _sessionService.listSessions();
      print('📋 [SessionController] Sessions data: $data');
      
      // Sort by lastUpdateTime (latest first)
      data.sort((a, b) {
        final timeA = double.tryParse(a['lastUpdateTime']?.toString() ?? '0') ?? 0;
        final timeB = double.tryParse(b['lastUpdateTime']?.toString() ?? '0') ?? 0;
        return timeB.compareTo(timeA);
      });
      
      sessions.value = data;
      filteredSessions.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void searchSessions(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredSessions.value = sessions;
    } else {
      filteredSessions.value = sessions.where((session) {
        final name = (session['session_name'] ?? '').toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    }
  }

  void setActiveSession(String sessionId) {
    activeSessionId.value = sessionId;
  }

  void clearActiveSession() {
    activeSessionId.value = null;
  }

  Future<String?> createNewSession() async {
    try {
      final data = await _sessionService.createSession();
      final sessionId = data['sessionId']?.toString();
      
      if (sessionId != null) {
        // Set as active session
        setActiveSession(sessionId);
        
        // Mark that refresh is needed when drawer opens next time
        needsRefresh.value = true;
        
        return sessionId;
      }
      return null;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create session', snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }

  String getTimeLabel(String? lastUpdateTime) {
    if (lastUpdateTime == null) return '';
    
    try {
      final timestamp = double.parse(lastUpdateTime);
      final date = DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).toInt());
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) {
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      }
      if (diff.inDays == 1) return 'Yesterday';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${date.day}/${date.month}';
    } catch (e) {
      return '';
    }
  }
}
