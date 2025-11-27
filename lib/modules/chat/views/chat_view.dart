import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hifi/modules/chat/controllers/chat_controller.dart';
import 'package:hifi/shared/themes/app_theme.dart';
import 'package:hifi/shared/widgets/sessions_drawer.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animValue = (value - delay).clamp(0.0, 1.0);
        final scale = 0.5 + (animValue * 0.5);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.primary500.withOpacity(0.6 + (animValue * 0.4)),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
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
                        controller: controller.scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.messages.length + (controller.isSending.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Show typing indicator as last item
                          if (index == controller.messages.length && controller.isSending.value) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _buildDot(0),
                                            const SizedBox(width: 4),
                                            _buildDot(1),
                                            const SizedBox(width: 4),
                                            _buildDot(2),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
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
                                              : Colors.white,
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
                      constraints: const BoxConstraints(minHeight: 50, maxHeight: 150),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFC6C9CE)),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(width: 20),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Icon(Icons.add, size: 20, color: Colors.grey),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: controller.messageController,
                              focusNode: controller.messageFocusNode,
                              onSubmitted: (_) => controller.sendMessage(),
                              maxLines: null,
                              textInputAction: TextInputAction.newline,
                              decoration: const InputDecoration(
                                hintText: "Ask your question...",
                                hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFC2C7D1),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Icon(Icons.mic, size: 18, color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, right: 10),
                            child: GestureDetector(
                              onTap: controller.sendMessage,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary500,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.send, size: 14, color: Colors.white),
                              ),
                            ),
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
      },
    );
  }
}
