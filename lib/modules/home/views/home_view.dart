import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hifi/modules/home/controllers/home_controller.dart';
import 'package:hifi/shared/themes/app_theme.dart';
import 'package:hifi/shared/widgets/sessions_drawer.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const SessionsDrawer(),
      drawerEnableOpenDragGesture: false,
      resizeToAvoidBottomInset: false,
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
        child: GestureDetector(
          onTap: () {
            print('🔍 HomeView: Screen tapped, unfocusing');
            controller.messageFocusNode.unfocus();
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
                  Padding(
                  padding: const EdgeInsets.fromLTRB(29, 13, 29, 0),
                  child: Row(
                    children: [
                      // Menu Icon
                      GestureDetector(
                        onTap: () {
                          print('🔍 HomeView: Menu tapped, unfocusing');
                          controller.messageFocusNode.unfocus();
                          FocusScope.of(context).unfocus();
                          Future.delayed(const Duration(milliseconds: 50), () {
                            scaffoldKey.currentState?.openDrawer();
                          });
                        },
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

                // Avatar and Connected Badge
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          // Avatar
                          Container(
                            width: 57,
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: const Icon(Icons.person, size: 32),
                          ),
                        ],
                      ),
                      // Connected Badge (right of avatar)
                      Positioned(
                        left: 73,
                        top: 59,
                        child: Container(
                          height: 30,
                          width: 85.714,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFC6C9CE)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 8.571,
                                height: 8.571,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Connected',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 37),

                // Greeting Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        'Hello, ${controller.userName.value}',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF161313),
                          height: 1.3,
                        ),
                      )),
                      const SizedBox(height: 5),
                      const Text(
                        'How may I help you?',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4F4A4A),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Search Bar / Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 50, maxHeight: 150),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFC6C9CE)),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(width: 21),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Icon(Icons.add, size: 20, color: Colors.grey),
                        ),
                        const SizedBox(width: 7),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            width: 1,
                            height: 20,
                            color: const Color(0xFFE0E0E0),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: IgnorePointer(
                            ignoring: false,
                            child: TextField(
                              controller: controller.messageController,
                              focusNode: controller.messageFocusNode,
                              onSubmitted: (_) => controller.sendMessageFromDashboard(),
                              maxLines: null,
                              textInputAction: TextInputAction.newline,
                              enableInteractiveSelection: true,
                              decoration: const InputDecoration(
                              hintText: "Ask your question...",
                              hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFC2C7D1),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Icon(Icons.mic, size: 18, color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, right: 13),
                          child: GestureDetector(
                            onTap: controller.sendMessageFromDashboard,
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
                const SizedBox(height: 10),

                // Suggestion Chips
                SizedBox(
                  height: 39,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.suggestionChips.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC6C9CE).withOpacity(0.2),
                          border: Border.all(color: Colors.white, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            controller.suggestionChips[index],
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF1B1A1D),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 27),

                // Services Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Services',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF404446),
                    ),
                  ),
                ),
                const SizedBox(height: 17),

                // Service Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  child: Row(
                    children: [
                      _buildServiceCard('Explore', Icons.explore_outlined),
                      const SizedBox(width: 8),
                      _buildServiceCard('Integrations', Icons.extension_outlined),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // Explore More Things Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Explore More Things',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF404446),
                    ),
                  ),
                ),
                const SizedBox(height: 17),

                // Usage and Stocks Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  child: Column(
                    children: [
                      _buildTrendingStocksCard(),
                      const SizedBox(height: 11),
                      _buildUsageCard(),
                    ],
                  ),
                ),
                const SizedBox(height: 9),

                // News Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'News',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF29303B),
                    ),
                  ),
                ),
                const SizedBox(height: 21),

                // News List
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 29),
                  padding: const EdgeInsets.all(23),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: Colors.white, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: List.generate(
                      controller.newsItems.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(bottom: index < 2 ? 11 : 0),
                        child: _buildNewsItem(controller.newsItems[index]),
                      ),
                    ),
                  ),
                ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 40),
                ],
              ),
            ),
          ),
        ),
      ),
        );
      },
    );
  }

  Widget _buildServiceCard(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (title == 'Explore') {
          Get.toNamed('/explore');
        } else if (title == 'Integrations') {
          Get.toNamed('/integrations');
        }
      },
      child: Container(
        width: 61,
        height: 61,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF404446)),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF404446),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageCard() {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Usage',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF29303B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Current plan: ${controller.currentPlan}',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8C8C91),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        value: controller.usagePercentage / 100,
                        strokeWidth: 6,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3461FD)),
                      ),
                    ),
                    Text(
                      '${controller.usagePercentage.toInt()}%',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0B0C14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              '${controller.promptsUsed} prompts used of ${controller.promptsTotal}',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0B0C14),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: const Text(
                  'Upgrade to Pro',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0B0C14),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildTrendingStocksCard() {
    return Container(
      width: double.infinity,
      height: 173,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trending Stocks',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF29303B),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.trendingStocks.length,
              itemBuilder: (context, index) {
                final stock = controller.trendingStocks[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: index < 2 ? 8 : 0),
                  child: Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.currency_bitcoin, size: 16),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stock['name'] as String,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF212529),
                              ),
                            ),
                            Text(
                              stock['symbol'] as String,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6C757D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            stock['price'] as String,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF343A40),
                            ),
                          ),
                          Text(
                            stock['change'] as String,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF21BF73),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(Map<String, dynamic> news) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news['title'] as String,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF29303B),
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    news['source'] as String,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF29303B),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    news['time'] as String,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF29303B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 81,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.image, size: 32, color: Colors.grey),
        ),
      ],
    );
  }
}
