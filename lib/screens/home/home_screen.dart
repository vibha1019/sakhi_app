import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../../providers/language_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});  // ADD THIS
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    
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
                            '${lang.translate('welcome')} 👋',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang.translate('micromitra'),
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Language Switcher
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.language, color: Colors.white),
                        onSelected: (String lang) {
                          context.read<LanguageProvider>().setLanguage(lang);
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(value: 'en', child: Text('🇬🇧 English')),
                          const PopupMenuItem(value: 'hi', child: Text('🇮🇳 हिन्दी')),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lang.translate('your_business_friend'),
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
                      title: lang.translate('pricing_calculator'),
                      description: lang.translate('pricing_desc'),
                      icon: Icons.calculate,
                      color: const Color(0xFF6B4CE6),
                      onTap: () => Navigator.pushNamed(context, '/pricing'),
                    ),
                    _FeatureCard(
                      title: lang.translate('marketing_tools'),
                      description: lang.translate('marketing_desc'),
                      icon: Icons.campaign,
                      color: const Color(0xFFFF6B9D),
                      onTap: () => Navigator.pushNamed(context, '/marketing'),
                    ),
                    _FeatureCard(
                      title: lang.translate('finance_tracker'),
                      description: lang.translate('finance_desc'),
                      icon: Icons.account_balance_wallet,
                      color: const Color(0xFF06D6A0),
                      onTap: () => Navigator.pushNamed(context, '/finance'),
                    ),
                    _FeatureCard(
                      title: lang.translate('business_tips'),
                      description: lang.translate('tips_desc'),
                      icon: Icons.lightbulb,
                      color: const Color(0xFFFFB800),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Coming soon!')),
                        );
                      },
                    ),
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