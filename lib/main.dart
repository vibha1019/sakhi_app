import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // NEW: dotenv import
import 'config/theme.dart';
import 'config/routes.dart';
import 'providers/user_provider.dart';
import 'providers/language_provider.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env
  await dotenv.load(fileName: "assets/.env");

  runApp(const MicroMitraApp());
}

class MicroMitraApp extends StatelessWidget {
  const MicroMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MaterialApp(
        title: 'MicroMitra',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: AppRoutes.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
