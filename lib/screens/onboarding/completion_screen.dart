import 'package:flutter/material.dart';
import 'package:pulseforge/widgets/gradient_container.dart';
import 'package:pulseforge/widgets/custom_button.dart';
import 'package:pulseforge/models/user.dart';
import 'package:pulseforge/services/auth_service.dart';
import 'package:pulseforge/services/auth_state_service.dart';

class CompletionScreen extends StatefulWidget {
  final FitnessGoal selectedGoal;
  final ActivityLevel selectedLevel;
  final List<WorkoutPreference> selectedPreferences;
  final Map<String, int> availability;
  final int? age;
  final double? height;
  final double? weight;
  final int? restingHeartRate;

  const CompletionScreen({
    super.key,
    required this.selectedGoal,
    required this.selectedLevel,
    required this.selectedPreferences,
    required this.availability,
    this.age,
    this.height,
    this.weight,
    this.restingHeartRate,
  });

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);

    try {
      // Convert enums to strings for Supabase
      final fitnessGoals = [_getGoalString(widget.selectedGoal)];
      final exercisePreferences = widget.selectedPreferences.map(_getPreferenceString).toList();
      final preferredDays = widget.availability.entries
          .where((entry) => entry.value > 0)
          .map((entry) => entry.key.toLowerCase())
          .toList();

      // Get user info from auth
      final currentUser = AuthService.instance.currentAuthUser;

      await AuthService.instance.createOrUpdateUserProfile(
        fullName: currentUser?.displayName,
        age: widget.age,
        height: widget.height,
        weight: widget.weight,
        fitnessGoals: fitnessGoals,
        fitnessLevel: _getLevelString(widget.selectedLevel),
        exercisePreferences: exercisePreferences,
        workoutFrequency: _getWorkoutFrequency(),
        workoutDuration: 30, // Default duration
        preferredDays: preferredDays,
        onboardingCompleted: true,
      );

      // Refresh auth state to trigger automatic navigation
      await AuthStateService.instance.refreshUserProfile();
      
      await Future.delayed(const Duration(seconds: 1)); // Simulate AI processing
      
      // AuthStateService will handle navigation automatically based on the updated profile
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getGoalString(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.weightLoss:
        return FitnessGoals.weightLoss;
      case FitnessGoal.muscleGain:
        return FitnessGoals.muscleGain;
      case FitnessGoal.endurance:
        return FitnessGoals.endurance;
      case FitnessGoal.strength:
        return FitnessGoals.strength;
      case FitnessGoal.flexibility:
        return FitnessGoals.flexibility;
      case FitnessGoal.general:
        return FitnessGoals.general;
    }
  }

  String _getLevelString(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.beginner:
        return FitnessLevels.beginner;
      case ActivityLevel.intermediate:
        return FitnessLevels.intermediate;
      case ActivityLevel.advanced:
        return FitnessLevels.advanced;
    }
  }

  String _getPreferenceString(WorkoutPreference preference) {
    switch (preference) {
      case WorkoutPreference.cardio:
        return ExercisePreferences.cardio;
      case WorkoutPreference.strength:
        return ExercisePreferences.strength;
      case WorkoutPreference.yoga:
        return ExercisePreferences.yoga;
      case WorkoutPreference.pilates:
        return ExercisePreferences.pilates;
      case WorkoutPreference.hiit:
        return ExercisePreferences.hiit;
      case WorkoutPreference.outdoor:
        return ExercisePreferences.outdoor;
      case WorkoutPreference.home:
        return ExercisePreferences.home;
    }
  }

  int _getWorkoutFrequency() {
    return widget.availability.values.where((time) => time > 0).length;
  }

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
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      '7/7',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Animated success icon
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
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
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                Text(
                  '🎉',
                  style: theme.textTheme.displayLarge,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  "You're all set!",
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'Our AI is now creating a personalized fitness plan just for you based on your preferences.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Summary cards
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _SummaryCard(
                          title: 'Your Goal',
                          value: _getGoalText(widget.selectedGoal),
                          icon: Icons.flag,
                          theme: theme,
                        ),
                        const SizedBox(height: 16),
                        _SummaryCard(
                          title: 'Activity Level',
                          value: _getLevelText(widget.selectedLevel),
                          icon: Icons.trending_up,
                          theme: theme,
                        ),
                        const SizedBox(height: 16),
                        _SummaryCard(
                          title: 'Workout Types',
                          value: '${widget.selectedPreferences.length} selected',
                          icon: Icons.fitness_center,
                          theme: theme,
                        ),
                        const SizedBox(height: 16),
                        _SummaryCard(
                          title: 'Weekly Schedule',
                          value: '${_getActiveDays()} days/week',
                          icon: Icons.schedule,
                          theme: theme,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                CustomButton(
                  text: 'Start Your Journey',
                  onPressed: _isLoading ? null : _completeOnboarding,
                  isLoading: _isLoading,
                  icon: _isLoading ? null : Icons.rocket_launch,
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGoalText(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.weightLoss:
        return 'Lose Weight';
      case FitnessGoal.muscleGain:
        return 'Build Muscle';
      case FitnessGoal.endurance:
        return 'Improve Endurance';
      case FitnessGoal.strength:
        return 'Get Stronger';
      case FitnessGoal.flexibility:
        return 'Increase Flexibility';
      case FitnessGoal.general:
        return 'Stay Healthy';
    }
  }

  String _getLevelText(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.beginner:
        return 'Beginner';
      case ActivityLevel.intermediate:
        return 'Intermediate';
      case ActivityLevel.advanced:
        return 'Advanced';
    }
  }

  int _getActiveDays() {
    return _getWorkoutFrequency();
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final ThemeData theme;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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