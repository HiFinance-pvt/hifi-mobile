import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hifi/modules/explore/controllers/explore_controller.dart';
import 'package:hifi/controllers/session_controller.dart';
import 'package:hifi/modules/explore/widgets/tax_preference_dialog.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.arrow_back, size: 24),
                    ),
                    const SizedBox(width: 28),
                    const Text(
                      'Explore Our Agents',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF161313),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(28, 8, 28, 0),
                child: Text(
                  'Discover our specialized Al agents designed to help you with various aspects of financial planning and management.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF29303B),
                    height: 1.67,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  itemCount: controller.agents.length,
                  itemBuilder: (context, index) {
                    final agent = controller.agents[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildAgentCard(agent),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgentCard(Map<String, dynamic> agent) {
    return GestureDetector(
      onTap: () async {
        if (agent['name'] == 'Tax-Mitra Agent') {
          showDialog(
            context: Get.context!,
            builder: (context) => TaxPreferenceDialog(
              onSubmit: (data) async {
                final sessionController = Get.find<SessionController>();
                final sessionId = await sessionController.createNewSession();
                if (sessionId != null) {
                  final updatedPrependText = _buildTaxPrependText(data, agent['prependText'] as String);
                  Get.toNamed('/chat', arguments: {
                    'sessionId': sessionId,
                    'agentPrependText': updatedPrependText,
                  });
                }
              },
            ),
          );
        } else {
          final sessionController = Get.find<SessionController>();
          final sessionId = await sessionController.createNewSession();
          if (sessionId != null) {
            Get.toNamed('/chat', arguments: {
              'sessionId': sessionId,
              'agentPrependText': agent['prependText'],
            });
          }
        }
      },
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(agent['color'] as int).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Color(agent['color'] as int).withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.smart_toy,
                  color: Color(agent['color'] as int),
                  size: 30,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            agent['name'] as String,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF29303B),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            agent['description'] as String,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF29303B),
              height: 1.67,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'KEY FEATURES',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (agent['features'] as List<String>).map((feature) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  border: Border.all(
                    color: Color(agent['color'] as int).withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  feature,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF29303B),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.arrow_forward,
                size: 20,
                color: Color(agent['color'] as int),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  String _buildTaxPrependText(Map<String, dynamic> data, String originalText) {
    final salary = data['salary'];
    final otherIncome = data['otherIncome'];
    final totalIncome = (double.parse(salary) + double.parse(otherIncome)).toStringAsFixed(0);
    final pan = data['pan'];
    final regime = data['taxRegime'];
    final residence = data['residenceStatus'];
    
    return originalText
        .replaceFirst('- PAN Number: ABCDE1234F', '- PAN Number: $pan')
        .replaceFirst('- Annual Salary: ₹10,000', '- Annual Salary: ₹$salary')
        .replaceFirst('- Other Income Sources: ₹1,000', '- Other Income Sources: ₹$otherIncome')
        .replaceFirst('- Total Annual Income: ₹11,000', '- Total Annual Income: ₹$totalIncome')
        .replaceFirst('- Preferred Tax Regime: New Tax Regime', '- Preferred Tax Regime: $regime')
        .replaceFirst('- Residence Status: Indian Resident', '- Residence Status: $residence');
  }
}
