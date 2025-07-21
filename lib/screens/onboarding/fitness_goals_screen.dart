import 'package:flutter/material.dart';
import 'package:pulseforge/widgets/gradient_container.dart';
import 'package:pulseforge/widgets/custom_button.dart';
import 'package:pulseforge/models/user.dart';
import 'package:pulseforge/screens/onboarding/activity_level_screen.dart';

class FitnessGoalsScreen extends StatefulWidget {
  const FitnessGoalsScreen({super.key});

  @override
  State<FitnessGoalsScreen> createState() => _FitnessGoalsScreenState();
}

class _FitnessGoalsScreenState extends State<FitnessGoalsScreen> {
  FitnessGoal? selectedGoal = FitnessGoal.strength;

  final List<GoalOption> goalOptions = [
    GoalOption(
      goal: FitnessGoal.weightLoss,
      title: 'Lose Weight',
      description: 'Burn calories and shed pounds',
      icon: Icons.trending_down,
      color: Colors.orange,
    ),
    GoalOption(
      goal: FitnessGoal.muscleGain,
      title: 'Build Muscle',
      description: 'Gain strength and muscle mass',
      icon: Icons.fitness_center,
      color: Colors.red,
    ),
    GoalOption(
      goal: FitnessGoal.endurance,
      title: 'Improve Endurance',
      description: 'Boost cardiovascular health',
      icon: Icons.directions_run,
      color: Colors.blue,
    ),
    GoalOption(
      goal: FitnessGoal.strength,
      title: 'Get Stronger',
      description: 'Increase overall strength',
      icon: Icons.sports_gymnastics,
      color: Colors.purple,
    ),
    GoalOption(
      goal: FitnessGoal.flexibility,
      title: 'Increase Flexibility',
      description: 'Improve mobility and range',
      icon: Icons.self_improvement,
      color: Colors.green,
    ),
    GoalOption(
      goal: FitnessGoal.general,
      title: 'Stay Healthy',
      description: 'Maintain overall wellness',
      icon: Icons.favorite,
      color: Colors.pink,
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
                      '1/7',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  '🎯',
                  style: theme.textTheme.displayLarge,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  "What's your main\nfitness goal?",
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'This helps us create a personalized workout plan for you.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: goalOptions.length,
                    itemBuilder: (context, index) {
                      final option = goalOptions[index];
                      final isSelected = selectedGoal == option.goal;
                      
                      return GestureDetector(
                        onTap: () => setState(() => selectedGoal = option.goal),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: option.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  option.icon,
                                  size: 32,
                                  color: option.color,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                option.title,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
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
                  onPressed: selectedGoal != null
                      ? () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ActivityLevelScreen(selectedGoal: selectedGoal!),
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

class GoalOption {
  final FitnessGoal goal;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  GoalOption({
    required this.goal,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}