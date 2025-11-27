import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hifi/services/session_service.dart';

class ChatController extends GetxController {
  final SessionService _sessionService = SessionService();
  final messageController = TextEditingController();
  final messageFocusNode = FocusNode();
  final scrollController = ScrollController();
  
  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;
  final sessionId = ''.obs;
  final sessionName = 'Chat Session'.obs;

  @override
  void onClose() {
    messageController.dispose();
    messageFocusNode.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

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
      
      // Scroll to bottom after loading messages
      Future.delayed(const Duration(milliseconds: 300), scrollToBottom);
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

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isSending.value) return;

    try {
      isSending.value = true;
      
      // Add user message immediately (optimistic UI)
      final userMessage = {
        'author': 'user',
        'content': {
          'parts': [{'text': text}]
        },
        'timestamp': DateTime.now().millisecondsSinceEpoch / 1000,
      };
      messages.add(userMessage);
      messageController.clear();
      
      // Scroll to bottom after adding message
      Future.delayed(const Duration(milliseconds: 100), scrollToBottom);

      // Call API
      final response = await _sessionService.sendMessage(sessionId.value, text);
      
      // Parse bot response and add to messages
      final botText = response['response']?['text']?.toString() ?? '';
      if (botText.isNotEmpty) {
        final botMessage = {
          'author': 'hifi_agent',
          'content': {
            'parts': [{'text': botText}]
          },
          'timestamp': DateTime.now().millisecondsSinceEpoch / 1000,
        };
        messages.add(botMessage);
        
        // Scroll to bottom after bot reply
        Future.delayed(const Duration(milliseconds: 100), scrollToBottom);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSending.value = false;
    }
  }
}
