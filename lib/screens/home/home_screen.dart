import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back! 👋',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'MicroMitra',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Business Friend',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Features Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _FeatureCard(
                      title: 'Pricing Calculator',
                      description: 'Calculate fair prices for your products',
                      icon: Icons.calculate,
                      color: const Color(0xFF6B4CE6),
                      onTap: () {
                        Navigator.pushNamed(context, '/pricing');
                      },
                    ),
                    _FeatureCard(
                      title: 'Marketing Tools',
                      description: 'Create flyers and ads instantly',
                      icon: Icons.campaign,
                      color: const Color(0xFFFF6B9D),
                      onTap: () {
                        Navigator.pushNamed(context, '/marketing');
                      },
                    ),
                    _FeatureCard(
                      title: 'Finance Tracker',
                      description: 'Track income and expenses',
                      icon: Icons.account_balance_wallet,
                      color: const Color(0xFF06D6A0),
                      onTap: () {
                        Navigator.pushNamed(context, '/finance');
                      },
                    ),
                    _FeatureCard(
                      title: 'Business Tips',
                      description: 'Learn business strategies',
                      icon: Icons.lightbulb,
                      color: const Color(0xFFFFB800),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Coming soon!')),
                        );
                      },
                    ),
                    _FeatureCard(
                      title: '🎤 Test Voice',
                      description: 'Test voice input',
                      icon: Icons.bug_report,
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pushNamed(context, '/voice-test');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Voice assistant placeholder
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Voice assistant coming soon!')),
          );
        },
        icon: const Icon(Icons.mic),
        label: const Text('Ask Sakhi'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}