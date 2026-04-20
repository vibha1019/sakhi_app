import 'package:flutter/material.dart';
import 'package:micromitra/screens/marketing/whatsapp_ad_generator_screen.dart';
import 'package:micromitra/screens/marketing/flyer_generator_screen.dart';
import 'package:micromitra/screens/marketing/social_media_post_screen.dart';

class MarketingGeneratorScreen extends StatelessWidget {
  const MarketingGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketing'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEAF0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.campaign, color: Color(0xFFD4537E), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Marketing',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Create materials in minutes',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Section label
          Text(
            'TOOLS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey[500],
                  letterSpacing: 0.8,
                ),
          ),
          const SizedBox(height: 8),

          // Tool rows
          _ToolRow(
            title: 'WhatsApp Ad',
            subtitle: 'Generate message-based ads',
            icon: Icons.message_rounded,
            iconColor: const Color(0xFF1D9E75),
            iconBg: const Color(0xFFE1F5EE),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WhatsAppAdGeneratorScreen()),
            ),
          ),
          const SizedBox(height: 8),
          _ToolRow(
            title: 'Flyer',
            subtitle: 'Design printable flyers',
            icon: Icons.article_rounded,
            iconColor: const Color(0xFFD4537E),
            iconBg: const Color(0xFFFFEAF0),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FlyerGeneratorScreen()),
            ),
          ),
          const SizedBox(height: 8),
          _ToolRow(
            title: 'Social Media Post',
            subtitle: 'Create posts for any platform',
            icon: Icons.image_rounded,
            iconColor: const Color(0xFF7F77DD),
            iconBg: const Color(0xFFEEEDFE),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SocialMediaPostScreen()),
            ),
          ),
          const SizedBox(height: 8),
          _ToolRow(
            title: 'Product Photo',
            subtitle: 'Enhance product images',
            icon: Icons.photo_camera_rounded,
            iconColor: const Color(0xFFBA7517),
            iconBg: const Color(0xFFFAEEDA),
            comingSoon: true,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Photo Enhancer — coming soon!')),
            ),
          ),

          const SizedBox(height: 20),

          // Info footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pick a tool to get started — results ready in under a minute.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final VoidCallback onTap;
  final bool comingSoon;

  const _ToolRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.onTap,
    this.comingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: comingSoon ? 0.55 : 1.0,
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              )),
                      Text(subtitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[600])),
                    ],
                  ),
                ),
                if (comingSoon)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'soon',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Colors.grey[500]),
                    ),
                  )
                else
                  Icon(Icons.chevron_right, color: Colors.grey[400], size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}