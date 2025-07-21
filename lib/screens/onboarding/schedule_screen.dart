import 'package:flutter/material.dart';
import 'package:pulseforge/widgets/gradient_container.dart';
import 'package:pulseforge/widgets/custom_button.dart';
import 'package:pulseforge/models/user.dart';
import 'package:pulseforge/screens/onboarding/health_info_screen.dart';

class ScheduleScreen extends StatefulWidget {
  final FitnessGoal selectedGoal;
  final ActivityLevel selectedLevel;
  final List<WorkoutPreference> selectedPreferences;

  const ScheduleScreen({
    super.key,
    required this.selectedGoal,
    required this.selectedLevel,
    required this.selectedPreferences,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Map<String, int> availability = {
    'Monday': 1,  // Morning
    'Tuesday': 0, // Rest
    'Wednesday': 3, // Evening
    'Thursday': 0, // Rest
    'Friday': 1, // Morning
    'Saturday': 2, // Afternoon
    'Sunday': 0, // Rest
  };

  final List<String> timeSlots = ['Morning', 'Afternoon', 'Evening'];
  final List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

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
                      '4/7',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  '📅',
                  style: theme.textTheme.displayLarge,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  "When do you prefer\nto work out?",
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Select your preferred time for each day.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: weekdays.length,
                    itemBuilder: (context, index) {
                      final day = weekdays[index];
                      final selectedTime = availability[day] ?? 0;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                day,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: List.generate(4, (timeIndex) {
                                  final isRest = timeIndex == 0;
                                  final label = isRest ? 'Rest' : timeSlots[timeIndex - 1];
                                  final isSelected = selectedTime == timeIndex;
                                  
                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: timeIndex < 3 ? 8 : 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            availability[day] = timeIndex;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: isSelected
                                                  ? theme.colorScheme.primary
                                                  : theme.colorScheme.outline.withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: Text(
                                            label,
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: isSelected
                                                  ? theme.colorScheme.primary
                                                  : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
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
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HealthInfoScreen(
                        selectedGoal: widget.selectedGoal,
                        selectedLevel: widget.selectedLevel,
                        selectedPreferences: widget.selectedPreferences,
                        availability: availability,
                      ),
                    ),
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