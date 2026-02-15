import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:hifi/services/session_service.dart';
import 'package:hifi/shared/models/agent_response_parser.dart';
import 'package:hifi/shared/models/agent_response.dart';
import 'dart:convert';

class ChatController extends GetxController {
  final SessionService _sessionService = SessionService();
  final messageController = TextEditingController();
  late final FocusNode messageFocusNode;
  final scrollController = ScrollController();
  
  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;
  final sessionId = ''.obs;
  final sessionName = 'Chat Session'.obs;
  final agentPrependText = ''.obs;
  final isFirstMessage = true.obs;

  @override
  void onInit() {
    super.onInit();
    messageFocusNode = FocusNode();
    messageFocusNode.addListener(() {
      print('🔍 ChatController: Focus changed - hasFocus: ${messageFocusNode.hasFocus}');
    });
    
    final args = Get.arguments;
    
    if (args is Map<String, dynamic>) {
      sessionId.value = args['sessionId'] ?? '';
      final initialMessage = args['initialMessage'] as String?;
      agentPrependText.value = args['agentPrependText'] ?? '';
      
      if (sessionId.value.isNotEmpty) {
        // Skip loading for new sessions, just send the initial message
        if (initialMessage != null && initialMessage.isNotEmpty) {
          messageController.text = initialMessage;
          sendMessage();
        } else {
          // Only load if no initial message (existing session)
          loadSession();
        }
      }
    } else if (args is String) {
      sessionId.value = args;
      agentPrependText.value = '';
      if (sessionId.value.isNotEmpty) {
        loadSession();
      }
    }
  }

  @override
  void onClose() {
    print('🔍 ChatController: onClose called');
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

  Future<void> loadSession() async {
    try {
      isLoading.value = true;
      final data = await _sessionService.getSession(sessionId.value);
      
      sessionName.value = data['session_name']?.toString() ?? 'Chat Session';
      final events = data['events'] as List? ?? [];
      
      // Parse each message using the same logic as real-time
      final parsedMessages = <Map<String, dynamic>>[];
      
      for (final event in events) {
        final eventMap = event as Map<String, dynamic>;
        
        if (isUserMessage(eventMap)) {
          // User messages - keep as is
          parsedMessages.add(eventMap);
        } else {
          // Bot messages - apply agent parsing
          final rawText = getMessageText(eventMap);
          if (rawText.isNotEmpty) {
            try {
              final agentResponse = AgentResponseParser.parseResponse(rawText);
              final parsedMessage = {
                ...eventMap,
                'content': {
                  'parts': [{'text': agentResponse.message}]
                },
                'agentResponse': agentResponse,
              };
              parsedMessages.add(parsedMessage);
              print('📋 [LOAD_SESSION] Parsed ${agentResponse.agentType} message');
            } catch (e) {
              // Fallback to original message
              parsedMessages.add(eventMap);
              print('📋 [LOAD_SESSION] Parse failed, using raw text');
            }
          } else {
            parsedMessages.add(eventMap);
          }
        }
      }
      
      messages.value = parsedMessages;
      
      // Scroll to bottom after loading messages
      Future.delayed(const Duration(milliseconds: 300), scrollToBottom);
    } catch (e) {
      print('⚠️ [ChatController] Could not load session, starting fresh: $e');
      // Don't show error, just start with empty messages
      messages.value = [];
      sessionName.value = 'Chat Session';
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
      
      // Prepare message text with prepend if first message
      String messageToSend = text;
      if (isFirstMessage.value && agentPrependText.value.isNotEmpty) {
        messageToSend = '${agentPrependText.value}\n\n$text';
        isFirstMessage.value = false;
      }
      
      // Add user message immediately (optimistic UI)
      final userMessage = {
        'author': 'user',
        'content': {
          'parts': [{'text': messageToSend}]
        },
        'timestamp': DateTime.now().millisecondsSinceEpoch / 1000,
      };
      messages.add(userMessage);
      messageController.clear();
      
      // Scroll to bottom after adding message
      Future.delayed(const Duration(milliseconds: 100), scrollToBottom);

      // Call API
      final response = await _sessionService.sendMessage(sessionId.value, messageToSend);
      
      print('📊 [CHAT_PARSING] Raw API Response:');
      print('📊 $response');
      
      // Parse bot response using agent parser
      String botText = '';
      AgentResponse? agentResponse;
      
      try {
        final responseText = response['response']?['text']?.toString() ?? '';
        print('📊 [CHAT_PARSING] Raw response text: "$responseText"');
        
        if (responseText.isNotEmpty) {
          // Use agent parser to detect type and extract data
          agentResponse = AgentResponseParser.parseResponse(responseText);
          botText = agentResponse.message;
          
          print('📊 [AGENT_DETECTION] Agent Type: ${agentResponse.agentType}');
          print('📊 [AGENT_DETECTION] Response Type: ${agentResponse.responseType}');
          print('📊 [AGENT_DETECTION] Has Questions: ${agentResponse.hasQuestions}');
          print('📊 [AGENT_DETECTION] Has Progress: ${agentResponse.hasProgress}');
          print('📊 [AGENT_DETECTION] Action: ${agentResponse.action}');
          print('📊 [CHAT_PARSING] Final message: "$botText"');
        }
      } catch (e) {
        print('📊 [CHAT_PARSING] Error parsing response: $e');
        // Fallback to simple text extraction
        botText = response['response']?['text']?.toString() ?? '';
      }
      
      if (botText.isNotEmpty) {
        final botMessage = {
          'author': 'hifi_agent',
          'content': {
            'parts': [{'text': botText}]
          },
          'timestamp': DateTime.now().millisecondsSinceEpoch / 1000,
          'agentResponse': agentResponse, // Store parsed response for UI
        };
        print('📊 [CHAT_PARSING] Created bot message structure');
        messages.add(botMessage);
        
        // Scroll to bottom after bot reply
        Future.delayed(const Duration(milliseconds: 100), scrollToBottom);
      }
    } on DioException catch (e) {
      print('❌ [CHAT_ERROR] Network error: ${e.message}');
      String errorMessage = 'Network error';
      
      if (e.response?.statusCode == 500) {
        errorMessage = 'Server error. The backend service is experiencing issues. Please try again later.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timed out. The agent is taking longer than usual to respond.';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection.';
      }
      
      Get.snackbar(
        'Connection Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      print('📊 [CHAT_PARSING] Error parsing response: $e');
      // Show user-friendly error message
      Get.snackbar(
        'Response Error',
        'Failed to parse agent response',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSending.value = false;
    }
  }
}
