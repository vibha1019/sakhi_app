import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'providers/user_provider.dart';
import 'providers/language_provider.dart';
import 'firebase_options.dart';
import 'screens/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        debugShowCheckedModeBanner: false,
        // AuthWrapper replaces initialRoute — it decides login vs home
        // Keep routes for named navigation elsewhere in the app
        routes: AppRoutes.routes,
      ),
    );
  }
}