import 'package:flutter/material.dart';

class MarketingGeneratorScreen extends StatelessWidget {
  const MarketingGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketing Tools'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Card(
              color: const Color(0xFFFF6B9D).withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.campaign,
                      size: 40,
                      color: const Color(0xFFFF6B9D),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Marketing Materials',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Professional ads in minutes',
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

            // Marketing Options Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _MarketingOption(
                  title: 'WhatsApp Ad',
                  icon: Icons.message,
                  color: const Color(0xFF25D366),
                  onTap: () {
                    _showComingSoon(context, 'WhatsApp Ad Creator');
                  },
                ),
                _MarketingOption(
                  title: 'Flyer',
                  icon: Icons.article,
                  color: const Color(0xFFFF6B9D),
                  onTap: () {
                    _showComingSoon(context, 'Flyer Generator');
                  },
                ),
                _MarketingOption(
                  title: 'Social Media Post',
                  icon: Icons.image,
                  color: const Color(0xFF6B4CE6),
                  onTap: () {
                    _showComingSoon(context, 'Social Media Post Creator');
                  },
                ),
                _MarketingOption(
                  title: 'Product Photo',
                  icon: Icons.photo_camera,
                  color: const Color(0xFFFFB800),
                  onTap: () {
                    _showComingSoon(context, 'Photo Enhancer');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Start Guide
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.help_outline, color: Color(0xFF6B4CE6)),
                        const SizedBox(width: 8),
                        Text(
                          'How It Works',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _StepItem(
                      number: '1',
                      text: 'Choose the type of marketing material',
                    ),
                    _StepItem(
                      number: '2',
                      text: 'Tell us about your product or service',
                    ),
                    _StepItem(
                      number: '3',
                      text: 'AI generates professional content',
                    ),
                    _StepItem(
                      number: '4',
                      text: 'Share directly to WhatsApp or social media',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sample Templates Preview
            Text(
              'Sample Templates',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _TemplatePlaceholder(color: Colors.blue.shade100),
                  const SizedBox(width: 16),
                  _TemplatePlaceholder(color: Colors.pink.shade100),
                  const SizedBox(width: 16),
                  _TemplatePlaceholder(color: Colors.purple.shade100),
                  const SizedBox(width: 16),
                  _TemplatePlaceholder(color: Colors.green.shade100),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showComingSoon(context, 'AI Marketing Assistant');
        },
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Generate'),
        backgroundColor: const Color(0xFFFF6B9D),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming soon! Your teammate will build this.'),
        backgroundColor: const Color(0xFF6B4CE6),
      ),
    );
  }
}

class _MarketingOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MarketingOption({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String text;

  const _StepItem({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B9D).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B9D),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplatePlaceholder extends StatelessWidget {
  final Color color;

  const _TemplatePlaceholder({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(
        child: Icon(Icons.image, size: 48, color: Colors.white70),
      ),
    );
  }
}