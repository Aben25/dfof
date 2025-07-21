import 'package:flutter/material.dart';
import 'package:pulseforge/widgets/gradient_container.dart';
import 'package:pulseforge/widgets/custom_button.dart';
import 'package:pulseforge/models/user.dart';
import 'package:pulseforge/screens/onboarding/preferences_screen.dart';

class ActivityLevelScreen extends StatefulWidget {
  final FitnessGoal selectedGoal;

  const ActivityLevelScreen({super.key, required this.selectedGoal});

  @override
  State<ActivityLevelScreen> createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen> {
  ActivityLevel? selectedLevel = ActivityLevel.intermediate;

  final List<LevelOption> levelOptions = [
    LevelOption(
      level: ActivityLevel.beginner,
      title: 'Beginner',
      description: 'New to fitness or getting back into it',
      subtitle: '0-2 workouts per week',
      icon: Icons.directions_walk,
      color: Colors.green,
    ),
    LevelOption(
      level: ActivityLevel.intermediate,
      title: 'Intermediate',
      description: 'Some experience with regular exercise',
      subtitle: '3-4 workouts per week',
      icon: Icons.directions_run,
      color: Colors.orange,
    ),
    LevelOption(
      level: ActivityLevel.advanced,
      title: 'Advanced',
      description: 'Very active with consistent training',
      subtitle: '5+ workouts per week',
      icon: Icons.flash_on,
      color: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: GradientContainer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      '2/7',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  '💪',
                  style: theme.textTheme.displayLarge,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  "What's your current\nactivity level?",
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  "Don't worry, we'll adjust your workouts accordingly.",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                Expanded(
                  child: Column(
                    children: levelOptions.map((option) {
                      final isSelected = selectedLevel == option.level;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => setState(() => selectedLevel = option.level),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: option.color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    option.icon,
                                    size: 28,
                                    color: option.color,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        option.title,
                                        style: theme.textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        option.subtitle,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.primary.withValues(alpha: 0.8),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        option.description,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: theme.colorScheme.primary,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                CustomButton(
                  text: 'Continue',
                  onPressed: selectedLevel != null
                      ? () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PreferencesScreen(
                                selectedGoal: widget.selectedGoal,
                                selectedLevel: selectedLevel!,
                              ),
                            ),
                          )
                      : null,
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

class LevelOption {
  final ActivityLevel level;
  final String title;
  final String description;
  final String subtitle;
  final IconData icon;
  final Color color;

  LevelOption({
    required this.level,
    required this.title,
    required this.description,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}