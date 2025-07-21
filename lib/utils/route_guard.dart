import 'package:flutter/material.dart';
import 'package:pulseforge/services/auth_state_service.dart';
import 'package:pulseforge/screens/auth/login_screen.dart';
import 'package:pulseforge/screens/onboarding/welcome_screen.dart';

class RouteGuard {
  static Widget guard({
    required Widget child,
    required AuthStatus requiredStatus,
    Widget? fallback,
  }) {
    return AuthGuardWidget(
      requiredStatus: requiredStatus,
      fallback: fallback,
      child: child,
    );
  }

  static Widget requireAuth({required Widget child}) {
    return guard(
      child: child,
      requiredStatus: AuthStatus.authenticated,
      fallback: const LoginScreen(),
    );
  }

  static Widget requireNoAuth({required Widget child}) {
    return guard(
      child: child,
      requiredStatus: AuthStatus.unauthenticated,
    );
  }

  static Widget requireOnboarding({required Widget child}) {
    return guard(
      child: child,
      requiredStatus: AuthStatus.onboardingRequired,
      fallback: const LoginScreen(),
    );
  }
}

class AuthGuardWidget extends StatelessWidget {
  final AuthStatus requiredStatus;
  final Widget child;
  final Widget? fallback;

  const AuthGuardWidget({
    super.key,
    required this.requiredStatus,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthStateService.instance,
      builder: (context, _) {
        final authState = AuthStateService.instance;

        // Show loading screen while auth state is being determined
        if (authState.status == AuthStatus.uninitialized || 
            authState.status == AuthStatus.authenticating) {
          return const AuthLoadingScreen();
        }

        // Check if current status matches required status
        if (authState.status == requiredStatus) {
          return child;
        }

        // Handle different auth states
        switch (authState.status) {
          case AuthStatus.unauthenticated:
            return fallback ?? const LoginScreen();
          case AuthStatus.onboardingRequired:
            return const WelcomeScreen();
          case AuthStatus.authenticated:
            // If we're here, it means the required status was different
            // This could happen if trying to access login/signup while authenticated
            if (requiredStatus == AuthStatus.unauthenticated) {
              // Redirect authenticated users away from auth screens
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              });
            }
            return child; // Return child while navigation is happening
          default:
            return fallback ?? const LoginScreen();
        }
      },
    );
  }
}

class AuthLoadingScreen extends StatelessWidget {
  const AuthLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.tertiary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 32),
              
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'Loading...',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}