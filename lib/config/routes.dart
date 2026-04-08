import 'package:flutter/material.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/pricing/pricing_calculator_screen.dart';
import '../screens/marketing/marketing_generator_screen.dart';
import '../screens/finance/finance_tracker_screen.dart';
import '../screens/test/voice_test_screen.dart';
import '../screens/auth_wrapper.dart'; // ADD THIS

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String home = '/home';
  static const String pricing = '/pricing';
  static const String marketing = '/marketing';
  static const String finance = '/finance';
  static const String voiceTest = '/voice-test';

  // ADD THIS — points to HomeScreen as the post-login destination
  static Widget get initialScreen => const HomeScreen();

  static Map<String, WidgetBuilder> get routes {
    return {
          splash: (context) => AuthWrapper(home: const HomeScreen()),
          welcome: (context) => const WelcomeScreen(),
          login: (context) => const LoginScreen(),
          home: (context) => const HomeScreen(),
          pricing: (context) => const PricingCalculatorScreen(),
          marketing: (context) => const MarketingGeneratorScreen(),
          finance: (context) => const FinanceTrackerScreen(),
          voiceTest: (context) => const VoiceTestScreen(),    };
  }
}