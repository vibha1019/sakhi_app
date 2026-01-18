import 'package:flutter/material.dart';

class PricingCalculatorScreen extends StatefulWidget {
  const PricingCalculatorScreen({super.key});

  @override
  State<PricingCalculatorScreen> createState() => _PricingCalculatorScreenState();
}

class _PricingCalculatorScreenState extends State<PricingCalculatorScreen> {
  final _materialCostController = TextEditingController();
  final _laborHoursController = TextEditingController();
  final _hourlyRateController = TextEditingController(text: '50');
  final _overheadPercentController = TextEditingController(text: '20');
  final _profitMarginController = TextEditingController(text: '20');
  
  Map<String, double>? _breakdown;

  @override
  void dispose() {
    _materialCostController.dispose();
    _laborHoursController.dispose();
    _hourlyRateController.dispose();
    _overheadPercentController.dispose();
    _profitMarginController.dispose();
    super.dispose();
  }

  void _calculatePrice() {
    final materialCost = double.tryParse(_materialCostController.text) ?? 0;
    final laborHours = double.tryParse(_laborHoursController.text) ?? 0;
    final hourlyRate = double.tryParse(_hourlyRateController.text) ?? 50;
    final overheadPercent = double.tryParse(_overheadPercentController.text) ?? 20;
    final profitMargin = double.tryParse(_profitMarginController.text) ?? 20;
    
    // Calculate each component
    final laborCost = laborHours * hourlyRate;
    final directCosts = materialCost + laborCost;
    final overheadAmount = directCosts * (overheadPercent / 100);
    final totalCosts = directCosts + overheadAmount;
    final profitAmount = totalCosts * (profitMargin / 100);
    final finalPrice = totalCosts + profitAmount;
    
    setState(() {
      _breakdown = {
        'materialCost': materialCost,
        'laborCost': laborCost,
        'directCosts': directCosts,
        'overheadAmount': overheadAmount,
        'totalCosts': totalCosts,
        'profitAmount': profitAmount,
        'finalPrice': finalPrice,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pricing Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Card(
              color: const Color(0xFF6B4CE6).withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.calculate,
                      size: 40,
                      color: const Color(0xFF6B4CE6),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Calculate Fair Prices',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Never undercharge again!',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Material Cost Input
            TextField(
              controller: _materialCostController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Material Cost',
                hintText: 'Enter cost of materials in ₹',
                prefixIcon: Icon(Icons.shopping_bag),
              ),
            ),
            const SizedBox(height: 16),

            // Labor Hours Input
            TextField(
              controller: _laborHoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Labor Hours',
                hintText: 'How many hours did it take?',
                prefixIcon: Icon(Icons.access_time),
              ),
            ),
            const SizedBox(height: 16),

            // Hourly Rate Input
            TextField(
              controller: _hourlyRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Your Hourly Rate (₹)',
                hintText: 'How much per hour for your work?',
                prefixIcon: Icon(Icons.currency_rupee),
                helperText: 'Your time is valuable! This is what you earn per hour.',
                helperMaxLines: 2,
              ),
            ),
            const SizedBox(height: 16),

            // Overhead Percentage Input
            TextField(
              controller: _overheadPercentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Overhead (%)',
                hintText: 'Extra costs like rent, electricity',
                prefixIcon: Icon(Icons.home_work),
                helperText: 'Your business costs: rent, electricity, tools. Usually 15-25%.',
                helperMaxLines: 2,
              ),
            ),
            const SizedBox(height: 16),

            // Profit Margin Input
            TextField(
              controller: _profitMarginController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Profit Margin (%)',
                hintText: 'Your earnings after all costs',
                prefixIcon: Icon(Icons.trending_up),
                helperText: 'This is YOUR profit to keep and grow your business. Usually 20-40%.',
                helperMaxLines: 2,
              ),
            ),
            const SizedBox(height: 24),

            // Calculate Button
            ElevatedButton.icon(
              onPressed: _calculatePrice,
              icon: const Icon(Icons.calculate),
              label: const Text('Calculate Price'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),

            // Result Card with Breakdown
            if (_breakdown != null) ...[
              Card(
                color: const Color(0xFF06D6A0).withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 60,
                        color: const Color(0xFF06D6A0),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Final Price to Charge',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${_breakdown!['finalPrice']!.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: const Color(0xFF06D6A0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Detailed Breakdown Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            color: const Color(0xFF6B4CE6),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Price Breakdown',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Understanding where your money goes:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _BreakdownItem(
                        title: 'Material Cost',
                        amount: _breakdown!['materialCost']!,
                        description: 'What you spent on supplies and materials',
                        icon: Icons.shopping_bag,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 12),

                      _BreakdownItem(
                        title: 'Labor Cost',
                        amount: _breakdown!['laborCost']!,
                        description: 'Payment for your time and skills (${_laborHoursController.text} hours × ₹${_hourlyRateController.text}/hour)',
                        icon: Icons.person_outline,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 12),

                      Divider(),
                      _BreakdownItem(
                        title: 'Direct Costs',
                        amount: _breakdown!['directCosts']!,
                        description: 'Materials + Labor = Basic costs',
                        icon: Icons.calculate,
                        color: Colors.grey,
                        isBold: true,
                      ),
                      const SizedBox(height: 12),

                      _BreakdownItem(
                        title: 'Overhead',
                        amount: _breakdown!['overheadAmount']!,
                        description: 'Business expenses: rent, electricity, tools (${_overheadPercentController.text}%)',
                        icon: Icons.home_work,
                        color: Colors.purple,
                      ),
                      const SizedBox(height: 12),

                      Divider(),
                      _BreakdownItem(
                        title: 'Total Costs',
                        amount: _breakdown!['totalCosts']!,
                        description: 'All expenses combined',
                        icon: Icons.assignment,
                        color: Colors.grey,
                        isBold: true,
                      ),
                      const SizedBox(height: 12),

                      _BreakdownItem(
                        title: 'Your Profit',
                        amount: _breakdown!['profitAmount']!,
                        description: 'Money YOU keep after all costs (${_profitMarginController.text}%)',
                        icon: Icons.savings,
                        color: const Color(0xFF06D6A0),
                        isBold: true,
                      ),
                      const SizedBox(height: 16),

                      Divider(thickness: 2),
                      const SizedBox(height: 8),
                      
                      _BreakdownItem(
                        title: 'FINAL PRICE',
                        amount: _breakdown!['finalPrice']!,
                        description: 'This is what you should charge the customer',
                        icon: Icons.monetization_on,
                        color: const Color(0xFF06D6A0),
                        isBold: true,
                        isLarge: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Profit Explanation Card
              Card(
                color: Colors.green.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.stars,
                            color: Colors.green[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Why This Price is Fair',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _ExplanationPoint('✓ Covers all your material costs'),
                      _ExplanationPoint('✓ Pays you fairly for your time and skills'),
                      _ExplanationPoint('✓ Includes business running costs'),
                      _ExplanationPoint('✓ Gives you profit to save and grow'),
                      const SizedBox(height: 8),
                      Text(
                        'If you charge less than ₹${_breakdown!['finalPrice']!.toStringAsFixed(2)}, you are losing money!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Tips Card
            Card(
              color: const Color(0xFFFFB800).withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: const Color(0xFFFFB800),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pricing Tips',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _TipItem('Include ALL costs: materials, time, overhead'),
                    _TipItem('Don\'t forget to value your time!'),
                    _TipItem('Check competitor prices in your area'),
                    _TipItem('Adjust based on your experience level'),
                    _TipItem('More experience = you can charge higher hourly rates'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  final String title;
  final double amount;
  final String description;
  final IconData icon;
  final Color color;
  final bool isBold;
  final bool isLarge;

  const _BreakdownItem({
    required this.title,
    required this.amount,
    required this.description,
    required this.icon,
    required this.color,
    this.isBold = false,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: isLarge ? 28 : 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    fontSize: isLarge ? 18 : null,
                  ),
                ),
              ),
              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: isLarge ? 20 : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExplanationPoint extends StatelessWidget {
  final String text;

  const _ExplanationPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;

  const _TipItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}