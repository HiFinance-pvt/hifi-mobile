import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaxPreferenceDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const TaxPreferenceDialog({super.key, required this.onSubmit});

  @override
  State<TaxPreferenceDialog> createState() => _TaxPreferenceDialogState();
}

class _TaxPreferenceDialogState extends State<TaxPreferenceDialog> {
  final formKey = GlobalKey<FormState>();
  final salaryController = TextEditingController();
  final otherIncomeController = TextEditingController();
  final panController = TextEditingController();
  final tanController = TextEditingController();
  String residenceStatus = 'Indian Resident';
  String taxRegime = 'New Tax Regime';

  @override
  void dispose() {
    salaryController.dispose();
    otherIncomeController.dispose();
    panController.dispose();
    tanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tax Analysis Preference',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF161313),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Provide your income details for personalized tax planning',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 24),
                
                TextFormField(
                  controller: salaryController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total Annual Salary (₹)',
                    hintText: 'Your total annual salary including basic, allowances, and bonuses',
                    hintStyle: const TextStyle(fontSize: 11),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (double.tryParse(value) == null) return 'Invalid amount';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: otherIncomeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Other Income Sources (₹)',
                    hintText: 'Rental income, interest, capital gains, etc',
                    hintStyle: const TextStyle(fontSize: 11),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (double.tryParse(value) == null) return 'Invalid amount';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: panController,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: 'PAN Number',
                    hintText: 'Format: ABCDE1234F',
                    hintStyle: const TextStyle(fontSize: 11),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    counterText: '',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length != 10) return 'Must be 10 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                const Text(
                  'Residence Status',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF161313),
                  ),
                ),
                const SizedBox(height: 8),
                _buildRadioOption(
                  'Indian Resident',
                  'Indian citizen or resident for tax purposes',
                  residenceStatus == 'Indian Resident',
                  () => setState(() => residenceStatus = 'Indian Resident'),
                ),
                _buildRadioOption(
                  'Foreign Resident',
                  'Non-resident or foreign citizen',
                  residenceStatus == 'Foreign Resident',
                  () => setState(() => residenceStatus = 'Foreign Resident'),
                ),
                const SizedBox(height: 20),
                
                const Text(
                  'Preferred Tax Regime',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF161313),
                  ),
                ),
                const SizedBox(height: 8),
                _buildTaxRegimeOption(
                  'Old Tax Regime',
                  'Traditional regime with deductions and exemptions',
                  ['Section 80C deductions up to ₹1.5L', 'HRA exemption', 'Section 80D health insurance'],
                  taxRegime == 'Old Tax Regime',
                  () => setState(() => taxRegime = 'Old Tax Regime'),
                ),
                const SizedBox(height: 12),
                _buildTaxRegimeOption(
                  'New Tax Regime',
                  'Simplified regime with lower tax rates',
                  ['Lower tax rates', 'No complex deductions', 'Simplified tax filing'],
                  taxRegime == 'New Tax Regime',
                  () => setState(() => taxRegime = 'New Tax Regime'),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: tanController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: 'Employee TAN (Optional)',
                    hintText: 'Tax Deduction Account Number',
                    hintStyle: const TextStyle(fontSize: 11),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        widget.onSubmit({
                          'salary': salaryController.text,
                          'otherIncome': otherIncomeController.text,
                          'pan': panController.text,
                          'residenceStatus': residenceStatus,
                          'taxRegime': taxRegime,
                          'tan': tanController.text,
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3461FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title, String subtitle, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? const Color(0xFF3461FD) : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? const Color(0xFF3461FD) : const Color(0xFF9CA3AF),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? const Color(0xFF161313) : const Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxRegimeOption(String title, String subtitle, List<String> benefits, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? const Color(0xFF3461FD) : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: selected ? const Color(0xFF3461FD) : const Color(0xFF9CA3AF),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected ? const Color(0xFF161313) : const Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Key Benefits:',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 4),
            ...benefits.map((benefit) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 2),
              child: Row(
                children: [
                  const Text('• ', style: TextStyle(color: Color(0xFF9CA3AF))),
                  Text(
                    benefit,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
