import 'package:get/get.dart';
import 'package:hifi/services/session_service.dart';

class ChatController extends GetxController {
  final SessionService _sessionService = SessionService();
  
  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final sessionId = ''.obs;
  final sessionName = 'Chat Session'.obs;

  @override
  void onInit() {
    super.onInit();
    sessionId.value = Get.arguments as String? ?? '';
    if (sessionId.value.isNotEmpty) {
      loadSession();
    }
  }

  Future<void> loadSession() async {
    try {
      isLoading.value = true;
      final data = await _sessionService.getSession(sessionId.value);
      
      sessionName.value = data['session_name']?.toString() ?? 'Chat Session';
      final events = data['events'] as List? ?? [];
      
      messages.value = events.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load chat', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  String getMessageText(Map<String, dynamic> event) {
    try {
      final parts = event['content']?['parts'] as List?;
      if (parts != null && parts.isNotEmpty) {
        final text = parts[0]['text'];
        if (text != null) return text.toString();
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  bool isUserMessage(Map<String, dynamic> event) {
    return event['author'] == 'user';
  }
}
