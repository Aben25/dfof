import 'package:flutter/material.dart';
import 'package:pulseforge/widgets/gradient_container.dart';
import 'package:pulseforge/widgets/custom_button.dart';
import 'package:pulseforge/models/workout.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  WorkoutSession? activeWorkout;
  List<WorkoutSession> recentWorkouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  void _loadWorkouts() {
    setState(() {
      recentWorkouts = WorkoutData.getSampleWorkouts();
      activeWorkout = recentWorkouts.firstWhere(
        (w) => w.status == WorkoutStatus.active,
        orElse: () => recentWorkouts.first,
      );
    });
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workout',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                if (activeWorkout != null) ...[
                  Text(
                    'Current Session',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _ActiveWorkoutCard(
                    workout: activeWorkout!,
                    theme: theme,
                    onStart: _startWorkout,
                    onPause: _pauseWorkout,
                    onComplete: _completeWorkout,
                  ),
                  
                  const SizedBox(height: 32),
                ],
                
                Row(
                  children: [
                    Text(
                      'Recent Workouts',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View all',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: recentWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = recentWorkouts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _WorkoutListItem(
                          workout: workout,
                          theme: theme,
                          onTap: () => _selectWorkout(workout),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startWorkout() {
    // Implement workout start logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout started! 💪')),
    );
  }

  void _pauseWorkout() {
    // Implement workout pause logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout paused')),
    );
  }

  void _completeWorkout() {
    // Implement workout completion logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Great workout! 🎆')),
    );
  }

  void _selectWorkout(WorkoutSession workout) {
    setState(() {
      activeWorkout = workout;
    });
  }
}

class _ActiveWorkoutCard extends StatelessWidget {
  final WorkoutSession workout;
  final ThemeData theme;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onComplete;

  const _ActiveWorkoutCard({
    required this.workout,
    required this.theme,
    required this.onStart,
    required this.onPause,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 32,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${workout.duration.inMinutes} min',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            workout.name,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '${workout.exercises.length} exercises',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: workout.status == WorkoutStatus.active ? 'Pause' : 'Start',
                  onPressed: workout.status == WorkoutStatus.active ? onPause : onStart,
                  isOutlined: true,
                  icon: workout.status == WorkoutStatus.active ? Icons.pause : Icons.play_arrow,
                ),
              ),
              if (workout.status == WorkoutStatus.active) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Complete',
                    onPressed: onComplete,
                    icon: Icons.check,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkoutListItem extends StatelessWidget {
  final WorkoutSession workout;
  final ThemeData theme;
  final VoidCallback onTap;

  const _WorkoutListItem({
    required this.workout,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getWorkoutIcon(),
                color: statusColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${workout.exercises.length} exercises • ${workout.duration.inMinutes} min',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  if (workout.status == WorkoutStatus.completed && workout.caloriesBurned != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${workout.caloriesBurned} kcal burned',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (workout.status) {
      case WorkoutStatus.completed:
        return Colors.green;
      case WorkoutStatus.active:
        return Colors.blue;
      case WorkoutStatus.planned:
        return Colors.orange;
      case WorkoutStatus.paused:
        return Colors.red;
    }
  }

  IconData _getWorkoutIcon() {
    switch (workout.type) {
      case WorkoutType.strength:
        return Icons.fitness_center;
      case WorkoutType.cardio:
        return Icons.directions_run;
      case WorkoutType.yoga:
        return Icons.self_improvement;
      case WorkoutType.hiit:
        return Icons.flash_on;
      case WorkoutType.flexibility:
        return Icons.accessibility_new;
      case WorkoutType.sports:
        return Icons.sports_tennis;
    }
  }
}