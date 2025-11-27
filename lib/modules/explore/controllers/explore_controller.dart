import 'package:get/get.dart';

class ExploreController extends GetxController {
  final agents = [
    {
      'name': 'SEBI Agent',
      'description': 'Your compliance watchdog. SEBI Agent ensures all your trades and financial decisions follow regulations. It flags risky moves, guides you through complex rules, and keeps you compliant.',
      'features': ['Trade Compliance', 'Risk Flagging', 'Regulatory Filings'],
      'color': 0xFFD4AF37,
      'isActive': true,
      'prependText': '''This is a SEBI compliance agent specialized in financial analysis and regulatory compliance. Welcome! I'm here to assist you with:

🏛️ **SEBI Regulations & Compliance**
- Investment guidelines and regulatory requirements
- Compliance checks for trading and investments
- SEBI disclosure requirements
- Regulatory updates and changes

📊 **Financial Analysis & Advisory**
- Investment portfolio analysis
- Risk assessment and management
- Market analysis and insights
- Investment strategy recommendations

🔍 **Anomaly Detection & Monitoring**
- Unusual market activity analysis
- Trading pattern analysis
- Compliance violation detection
- Risk monitoring guidelines

🎯 **Investment Guidance**
- Mutual fund regulations and selection
- Stock market compliance rules
- Investment planning strategies
- Regulatory best practices

How can I help you today? You can ask me about:
- Specific SEBI regulations
- Investment compliance requirements
- Market analysis and insights
- Risk management strategies
- Or any other financial compliance questions

What would you like to know?''',
    },
    {
      'name': 'Tax-Mitra Agent',
      'description': 'Your friendly tax sidekick. Tax-Mitra breaks down complex tax laws into human language. From ITR filing to deduction tracking—it helps you save money and stay stress-free.',
      'features': ['ITR Filing', 'Deduction Tracking', 'Tax Optimization'],
      'color': 0xFF9ACD32,
      'isActive': true,
      'prependText': '''This is a Tax-Mitra agent specialized in Indian tax laws and ITR filing procedures. I will immediately begin your tax analysis and filing process.

🚀 **Starting Tax Filing Process**
Based on your provided income details, I'm now initiating a comprehensive tax analysis and will guide you through the complete ITR filing procedure step-by-step.

📋 **What I'm Processing:**
- Calculating your exact tax liability under both Old and New Tax Regimes
- Identifying all applicable deductions and exemptions
- Determining optimal tax-saving strategies
- Preparing your ITR filing roadmap
- Computing advance tax requirements if applicable

💰 **Tax Optimization Analysis:**
- Section 80C deductions analysis (₹1.5L limit)
- Section 80D health insurance benefits
- HRA exemption calculations
- Home loan interest deductions
- NPS contributions under 80CCD(1B)
- Other eligible deductions based on your profile

📊 **ITR Filing Preparation:**
- Selecting appropriate ITR form (ITR-1, ITR-2, etc.)
- Document checklist preparation
- Tax computation and verification
- Filing deadline compliance
- TDS reconciliation and claims

I will now proceed with detailed calculations and provide step-by-step filing guidance without requiring any additional information from you.

📊 **User's Tax Information:**
- PAN Number: ABCDE1234F
- Annual Salary: ₹10,000
- Other Income Sources: ₹1,000
- Total Annual Income: ₹11,000
- Preferred Tax Regime: New Tax Regime
- Residence Status: Indian Resident

🎯 **Immediate Analysis Request:**
Based on the above tax information, please provide:

1. **Tax Liability Comparison:**
   - Calculate exact tax under Old Regime vs New Regime
   - Show potential savings between both regimes
   - Recommend the optimal regime for this income level

2. **Personalized Tax-Saving Strategies:**
   - Section 80C deductions (up to ₹1.5L limit)
   - Section 80D health insurance benefits
   - HRA exemption calculations (if applicable)
   - Home loan interest deductions
   - NPS additional deduction under 80CCD(1B)

3. **Deduction Optimization for This Income:**
   - List all available deductions for this income bracket
   - Calculate maximum possible tax savings
   - Suggest tax-efficient investment options

4. **FY 2023-24 Tax Planning:**
   - Important deadlines and compliance requirements
   - Advance tax payment calculations based on this income
   - ITR filing guidance and required documentation
   - Investment recommendations for remaining financial year

Please provide detailed calculations and actionable recommendations based on current Indian tax laws.''',
    },
    {
      'name': 'Debt-Squasher Agent',
      'description': 'Brutal on debt, soft on you. Debt-Squasher attacks your loans with ruthless efficiency—optimizing repayments, finding loopholes, and crushing your debt faster.',
      'features': ['Repayment Optimization', 'EMI Management', 'Debt Strategy'],
      'color': 0xFF4682B4,
      'isActive': true,
      'prependText': '''This is a debt management specialist focused on helping users eliminate debt efficiently. I have analyzed the user's debt situation and preferences.

**DEBT ANALYSIS SUMMARY:**
- Total Debt: ₹250,000
- Monthly Income: ₹80,000
- Monthly Expenses: ₹45,000
- Debt-to-Income Ratio: 31.25%
- Available for Debt Payment: ₹35,000

**USER PREFERENCES:**
- Target Duration: 24 months
- Payment Intensity: mild

**DEBT BREAKDOWN:**
- Credit Card 1: ₹50,000 @ 24% (Min: ₹2500)
- Personal Loan: ₹150,000 @ 12% (Min: ₹8000)
- Car Loan: ₹50,000 @ 8.5% (Min: ₹3000)

No payoff plan generated yet. Use this debt information to provide personalized debt reduction strategies and financial advice.

Based on this analysis, please provide:

1. A detailed debt reduction strategy tailored to their mild approach
2. Specific monthly payment recommendations
3. Tips for staying on track with the 24-month timeline
4. Potential ways to accelerate debt payoff
5. Strategies to avoid accumulating new debt

Let's create a actionable plan to become debt-free!''',
    },
    {
      'name': 'Trader Agent',
      'description': 'Built for the bold. Trader Agent gives you real-time signals, market heatmaps, and intuitive charts. Whether you\'re scalping or swing trading, it keeps you ahead of the market.',
      'features': ['Real-time Signals', 'Market Heatmaps', 'Trading Charts'],
      'color': 0xFFDC143C,
      'isActive': true,
      'prependText': '''This is a tax planning specialist focused on helping users optimize their tax liability and maximize savings. I have analyzed the user's tax situation and preferences.

**TAX ANALYSIS SUMMARY:**
- PAN Number: ABCDE1234F
- Total Salary: ₹10,000
- Other Income Sources: ₹1,000
- Total Income: ₹11,000
- Preferred Regime: New Tax Regime
- Residence Status: Indian Resident

**TAX LIABILITY COMPARISON:**
- Old Regime Tax: ₹0
- New Regime Tax: ₹0
- Potential Tax Savings: ₹0

**AVAILABLE DEDUCTIONS (Old Regime):**
- Section 80C: ₹1,100
- Section 80D (Health): ₹25,000
- Section 80TTA (Interest): ₹10,000
- HRA Exemption: ₹4,000
- Other Deductions: ₹50,000

**RECOMMENDATIONS:**
- Consider Section 80C investments up to ₹1.5L
- Health insurance premium under Section 80D
- HRA exemption if applicable
- NPS contribution for additional deduction

Use this tax information to provide personalized tax planning strategies and optimization advice.

Based on this analysis, please provide:

1. A detailed tax optimization strategy for the New Tax Regime
2. Specific deduction recommendations and investment suggestions
3. Tax-saving opportunities and strategies
4. Comparison between Old and New Tax Regime benefits
5. Long-term tax planning advice

Let's create an actionable tax optimization plan!''',
    },
  ];
}
