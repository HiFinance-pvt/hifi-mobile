import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/integrations_controller.dart';

class IntegrationsView extends GetView<IntegrationsController> {
  const IntegrationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back, size: 26, color: Color(0xFF161313)),
                    ),
                    const SizedBox(width: 27),
                    const Text(
                      'Integrations',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF161313),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, top: 9, right: 30),
                child: Text(
                  'Manage and customize tools you use every day.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF29303B),
                    height: 1.67,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refreshIntegrations,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    itemCount: controller.integrations.length,
                    itemBuilder: (context, index) {
                      final integration = controller.integrations[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: _buildIntegrationCard(integration),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntegrationCard(Map<String, String> integration) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.business,
                    size: 30,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          integration['name']!,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF29303B),
                            height: 1.25,
                          ),
                        ),
                        if (integration['status'] == 'coming_soon') ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3461FD).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Coming Soon',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3461FD),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      integration['url']!,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF29303B),
                        height: 1.58,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final state = controller.integrationStates[integration['name']];
                final isCheckingKite = integration['name'] == 'Zerodha' && controller.isCheckingKiteStatus.value;
                
                return Switch(
                  value: state?.value ?? false,
                  onChanged: isCheckingKite ? null : (value) => controller.toggleIntegration(integration['name']!),
                  activeColor: const Color(0xFF3461FD),
                );
              }),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            integration['description']!,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF29303B),
              height: 1.67,
            ),
          ),
        ],
      ),
    );
  }
}
