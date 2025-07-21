import 'package:flutter/material.dart';
import 'package:pulseforge/theme.dart';
import 'package:pulseforge/services/auth_state_service.dart';
import 'package:pulseforge/screens/auth/login_screen.dart';
import 'package:pulseforge/screens/main/main_navigation_screen.dart';
import 'package:pulseforge/screens/onboarding/welcome_screen.dart';
import 'package:pulseforge/config/supabase_config.dart';
import 'package:pulseforge/utils/route_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseConfig.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PulseForge',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
      // Add named routes for better navigation
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/onboarding': (context) => const WelcomeScreen(),
        '/main': (context) => const MainNavigationScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthStateService.instance,
      builder: (context, _) {
        final authState = AuthStateService.instance;

        switch (authState.status) {
          case AuthStatus.uninitialized:
          case AuthStatus.authenticating:
            return const AuthLoadingScreen();

          case AuthStatus.unauthenticated:
            return const LoginScreen();

          case AuthStatus.onboardingRequired:
            return const WelcomeScreen();

          case AuthStatus.authenticated:
            return const MainNavigationScreen();
        }
      },
    );
  }
}
