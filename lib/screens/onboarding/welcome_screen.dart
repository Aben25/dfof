import 'package:flutter/material.dart';
import 'package:pulseforge/widgets/gradient_container.dart';
import 'package:pulseforge/widgets/custom_button.dart';
import 'package:pulseforge/screens/onboarding/fitness_goals_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: GradientContainer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                
                // App Icon/Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.tertiary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                Text(
                  'Welcome to',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                
                Text(
                  'PulseForge',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    background: Paint()
                      ..shader = LinearGradient(
                        colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
                      ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'Your AI-powered fitness companion that adapts to your goals, tracks your progress, and motivates you every step of the way.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 60),
                
                // Feature highlights
                Column(
                  children: [
                    _FeatureItem(
                      icon: Icons.auto_awesome,
                      title: 'AI-Powered Workouts',
                      description: 'Personalized routines that evolve with you',
                      theme: theme,
                    ),
                    const SizedBox(height: 20),
                    _FeatureItem(
                      icon: Icons.track_changes,
                      title: 'Smart Progress Tracking',
                      description: 'Monitor your journey with detailed insights',
                      theme: theme,
                    ),
                    const SizedBox(height: 20),
                    _FeatureItem(
                      icon: Icons.psychology,
                      title: 'Intelligent Coaching',
                      description: 'Get real-time feedback and motivation',
                      theme: theme,
                    ),
                  ],
                ),
                
                const Spacer(),
                
                CustomButton(
                  text: "Let's Get Started",
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const FitnessGoalsScreen()),
                  ),
                  icon: Icons.arrow_forward,
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final ThemeData theme;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}