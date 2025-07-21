import 'package:flutter/material.dart';
import 'package:pulseforge/widgets/gradient_container.dart';
import 'package:pulseforge/widgets/custom_button.dart';
import 'package:pulseforge/models/user.dart';
import 'package:pulseforge/screens/onboarding/schedule_screen.dart';

class PreferencesScreen extends StatefulWidget {
  final FitnessGoal selectedGoal;
  final ActivityLevel selectedLevel;

  const PreferencesScreen({
    super.key,
    required this.selectedGoal,
    required this.selectedLevel,
  });

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  Set<WorkoutPreference> selectedPreferences = {
    WorkoutPreference.strength,
    WorkoutPreference.cardio,
    WorkoutPreference.hiit,
  };

  final List<PreferenceOption> preferenceOptions = [
    PreferenceOption(
      preference: WorkoutPreference.cardio,
      title: 'Cardio',
      description: 'Running, cycling, HIIT',
      icon: Icons.directions_run,
      color: Colors.red,
    ),
    PreferenceOption(
      preference: WorkoutPreference.strength,
      title: 'Strength Training',
      description: 'Weights, resistance',
      icon: Icons.fitness_center,
      color: Colors.blue,
    ),
    PreferenceOption(
      preference: WorkoutPreference.yoga,
      title: 'Yoga',
      description: 'Flexibility, mindfulness',
      icon: Icons.self_improvement,
      color: Colors.purple,
    ),
    PreferenceOption(
      preference: WorkoutPreference.pilates,
      title: 'Pilates',
      description: 'Core, stability',
      icon: Icons.accessibility_new,
      color: Colors.green,
    ),
    PreferenceOption(
      preference: WorkoutPreference.hiit,
      title: 'HIIT',
      description: 'High intensity intervals',
      icon: Icons.flash_on,
      color: Colors.orange,
    ),
    PreferenceOption(
      preference: WorkoutPreference.outdoor,
      title: 'Outdoor Activities',
      description: 'Fresh air workouts',
      icon: Icons.park,
      color: Colors.teal,
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
                      '3/7',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  '🏋️',
                  style: theme.textTheme.displayLarge,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  "What types of workouts\ndo you enjoy?",
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Select all that apply. You can always change this later.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: preferenceOptions.length,
                    itemBuilder: (context, index) {
                      final option = preferenceOptions[index];
                      final isSelected = selectedPreferences.contains(option.preference);
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedPreferences.remove(option.preference);
                            } else {
                              selectedPreferences.add(option.preference);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
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
                                  if (isSelected)
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                option.title,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                option.description,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 24),
                
                CustomButton(
                  text: 'Continue',
                  onPressed: selectedPreferences.isNotEmpty
                      ? () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ScheduleScreen(
                                selectedGoal: widget.selectedGoal,
                                selectedLevel: widget.selectedLevel,
                                selectedPreferences: selectedPreferences.toList(),
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

class PreferenceOption {
  final WorkoutPreference preference;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  PreferenceOption({
    required this.preference,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}