import 'package:flutter/material.dart';
import 'package:granth/pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:granth/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:granth/pages/mainpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
  ChangeNotifierProvider(
    create: (_) => GranthAuthProvider(),
    child: const MyApp(),
  ),
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F0E8),
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
      ),
      home: Consumer<GranthAuthProvider>(
  builder: (context, auth, _) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFF5F0E8),
            body: Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
          );
        }
        return snapshot.hasData ? MainPage() : const HomePage();
      },
    );
  },
),
    );
  }
}
