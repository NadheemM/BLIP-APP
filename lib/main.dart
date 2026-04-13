import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BlipApp());
}

class BlipApp extends StatelessWidget {
  const BlipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A3A6B),
          brightness: Brightness.light,
          primary: const Color(0xFF1A3A6B),
          secondary: const Color(0xFF4A7FC1),
          surface: const Color(0xFFF8F9FC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FC),
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1A3A6B),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      home: const AppEntry(),
    );
  }
}

/// Entry point — shows splash, then routes based on Firebase Auth state.
class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    // Show splash for 2.5 seconds
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // Check Firebase Auth persisted login state
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is already logged in — initialize notifications and go to home
      _initNotifications();
      _navigateTo(const HomeScreen());
    } else {
      // No user — show login screen
      _navigateTo(const LoginScreen());
    }
  }

  void _initNotifications() {
    // Initialize FCM after the user is authenticated
    NotificationService.initialize();
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
