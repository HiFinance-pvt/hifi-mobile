import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hifi/controllers/session_controller.dart';
import 'package:hifi/modules/chat/controllers/chat_controller.dart';
import 'package:hifi/modules/chat/views/chat_view.dart';
import 'package:hifi/modules/chat/bindings/chat_binding.dart';
import 'package:hifi/shared/themes/app_theme.dart';

class SessionsDrawer extends GetView<SessionController> {
  const SessionsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Check if refresh is needed when drawer opens
      if (controller.needsRefresh.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.needsRefresh.value = false;
          controller.fetchSessions();
        });
      }

      return Drawer(
      backgroundColor: AppTheme.gray900,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/hifi_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Hi-Fi',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.white70, size: 24),
                  ),
                ],
              ),
            ),

            // Search Bar - Temporarily disabled due to keyboard closing drawer issue
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Container(
            //     height: 48,
            //     decoration: BoxDecoration(
            //       color: AppTheme.gray800,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: TextFormField(
            //       onChanged: controller.searchSessions,
            //       style: const TextStyle(color: Colors.white70, fontSize: 14),
            //       decoration: const InputDecoration(
            //         hintText: 'Search sessions...',
            //         hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
            //         prefixIcon: Icon(Icons.search, color: Colors.white38, size: 20),
            //         border: InputBorder.none,
            //         contentPadding: EdgeInsets.symmetric(vertical: 14),
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),

            // New Chat Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final sessionId = await controller.createNewSession();
                    
                    if (sessionId != null) {
                      Get.back();
                      
                      // Check if already on chat page
                      if (Get.currentRoute == '/chat') {
                        Get.delete<ChatController>();
                        Get.off(
                          () => const ChatView(),
                          binding: ChatBinding(),
                          arguments: sessionId,
                        );
                      } else {
                        Get.toNamed('/chat', arguments: sessionId);
                      }
                    } else {
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary500,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'New Chat',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // CHATS Label
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'CHATS',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white38,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Sessions List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppTheme.primary500),
                  );
                }

                if (controller.filteredSessions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 48, color: Colors.white24),
                        const SizedBox(height: 16),
                        Text(
                          controller.sessions.isEmpty
                              ? 'No chats yet\nCreate a new chat to get started'
                              : 'No sessions found',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchSessions,
                  color: AppTheme.primary500,
                  backgroundColor: AppTheme.gray800,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: controller.filteredSessions.length,
                    itemBuilder: (context, index) {
                      final session = controller.filteredSessions[index];
                      final sessionId = session['id']?.toString() ?? '';
                      final sessionName = session['session_name']?.toString() ?? 'Chat Session';
                      final timeLabel = controller.getTimeLabel(session['lastUpdateTime']?.toString());

                      return Obx(() {
                        final isActive = controller.activeSessionId.value == sessionId;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: isActive ? AppTheme.gray800 : Colors.transparent,
                            border: Border.all(
                              color: isActive ? AppTheme.primary500 : Colors.transparent,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            onTap: () {
                              controller.setActiveSession(sessionId);
                              Get.back();
                              
                              // Check if already on chat page
                              if (Get.currentRoute == '/chat') {
                                // Delete and recreate controller
                                Get.delete<ChatController>();
                                Get.off(
                                  () => const ChatView(),
                                  binding: ChatBinding(),
                                  arguments: sessionId,
                                );
                              } else {
                                Get.toNamed('/chat', arguments: sessionId);
                              }
                            },
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            title: Text(
                              sessionName,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (timeLabel.isNotEmpty)
                                  Text(
                                    timeLabel,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 11,
                                      color: Colors.white38,
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.white54),
                                  onPressed: () => controller.deleteSession(sessionId),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                );
              }),
            ),
            ],
          ),
        ),
      ),
      );
    });
  }
}
