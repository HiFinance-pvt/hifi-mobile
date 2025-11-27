import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hifi/modules/chat/controllers/chat_controller.dart';
import 'package:hifi/shared/themes/app_theme.dart';
import 'package:hifi/shared/widgets/sessions_drawer.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const SessionsDrawer(),
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF3461FD).withOpacity(0.1),
              Colors.white,
              const Color(0xFF3461FD).withOpacity(0.05),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 13, 16, 0),
                child: Row(
                  children: [
                    // Menu Icon
                    GestureDetector(
                      onTap: () => scaffoldKey.currentState?.openDrawer(),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.menu, size: 20),
                      ),
                    ),
                    const Spacer(),
                    // Notification Bell
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.notifications_outlined, size: 20),
                    ),
                    const SizedBox(width: 12),
                    // Profile with PRO badge
                    Stack(
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.person, size: 16),
                        ),
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'PRO',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 6,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 0.48,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Messages List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(color: AppTheme.primary500),
                    );
                  }

                  if (controller.messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'No messages yet\nStart a conversation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: Colors.black38,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      final isUser = controller.isUserMessage(message);
                      final text = controller.getMessageText(message);

                      if (text.isEmpty) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            if (!isUser) ...[
                              // Bot Avatar
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(17.5),
                                ),
                                child: const Icon(Icons.smart_toy, size: 20),
                              ),
                              const SizedBox(width: 8),
                            ],
                            // Message Bubble
                            Flexible(
                              child: Column(
                                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  if (!isUser)
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        'HI-FI Bot',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          color: Color(0xFF1b1a1d),
                                        ),
                                      ),
                                    ),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? const Color(0xFFC6C9CE).withOpacity(0.2)
                                          : Colors.white.withOpacity(0.75),
                                      border: Border.all(
                                        color: isUser ? Colors.white : Colors.transparent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: isUser
                                        ? Text(
                                            text,
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 12,
                                              color: Color(0xFF1b1a1d),
                                              height: 1.67,
                                            ),
                                          )
                                        : MarkdownBody(
                                            data: text,
                                            styleSheet: MarkdownStyleSheet(
                                              p: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 12,
                                                color: Color(0xFF1b1a1d),
                                                height: 1.67,
                                              ),
                                              strong: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1b1a1d),
                                              ),
                                              listBullet: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 12,
                                                color: Color(0xFF1b1a1d),
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            if (isUser) ...[
                              const SizedBox(width: 8),
                              // User Avatar
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(17.5),
                                ),
                                child: const Icon(Icons.person, size: 20),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),

              // Input Field
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 0, 13, 16),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFC6C9CE)),
                    borderRadius: BorderRadius.circular(37.5),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      const Icon(Icons.add, size: 20, color: Colors.grey),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Ask questions, or type '@' to call Agent.",
                            hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFC2C7D1),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Icon(Icons.mic, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.primary500,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send, size: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
