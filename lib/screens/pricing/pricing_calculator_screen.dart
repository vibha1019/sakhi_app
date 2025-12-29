import 'package:flutter/material.dart';

class PricingCalculatorScreen extends StatefulWidget {
  const PricingCalculatorScreen({super.key});

  @override
  State<PricingCalculatorScreen> createState() => _PricingCalculatorScreenState();
}

class _PricingCalculatorScreenState extends State<PricingCalculatorScreen> {
  final _materialCostController = TextEditingController();
  final _laborHoursController = TextEditingController();
  String? _suggestedPrice;

  @override
  void dispose() {
    _materialCostController.dispose();
    _laborHoursController.dispose();
    super.dispose();
  }

  void _calculatePrice() {
    final materialCost = double.tryParse(_materialCostController.text) ?? 0;
    final laborHours = double.tryParse(_laborHoursController.text) ?? 0;
    
    // Simple pricing formula: (Materials + Labor) * 1.4 (40% markup)
    final laborCost = laborHours * 50; // ₹50 per hour
    final totalCost = materialCost + laborCost;
    final suggestedPrice = totalCost * 1.4;
    
    setState(() {
      _suggestedPrice = '₹${suggestedPrice.toStringAsFixed(2)}';
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

            // Result Card
            if (_suggestedPrice != null)
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
                        'Suggested Price',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _suggestedPrice!,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: const Color(0xFF06D6A0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This includes 40% profit margin',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

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