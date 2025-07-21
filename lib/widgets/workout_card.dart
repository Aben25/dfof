import 'package:flutter/material.dart';
import 'package:pulseforge/models/workout.dart';
import 'package:pulseforge/theme.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutSession workout;
  final VoidCallback? onTap;

  const WorkoutCard({
    super.key,
    required this.workout,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _getStatusColor();
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? DarkModeColors.darkCardBackground : LightModeColors.lightCardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? DarkModeColors.darkBorder : LightModeColors.lightBorder,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                const SizedBox(width: 12),
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
                      Text(
                        _getWorkoutTypeText(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.schedule,
                  label: '${workout.duration.inMinutes} min',
                  theme: theme,
                ),
                const SizedBox(width: 12),
                _InfoChip(
                  icon: Icons.fitness_center,
                  label: '${workout.exercises.length} exercises',
                  theme: theme,
                ),
                if (workout.caloriesBurned != null) ...[
                  const SizedBox(width: 12),
                  _InfoChip(
                    icon: Icons.local_fire_department,
                    label: '${workout.caloriesBurned} kcal',
                    theme: theme,
                    color: Colors.orange,
                  ),
                ],
              ],
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

  String _getStatusText() {
    switch (workout.status) {
      case WorkoutStatus.completed:
        return 'Completed';
      case WorkoutStatus.active:
        return 'Active';
      case WorkoutStatus.planned:
        return 'Planned';
      case WorkoutStatus.paused:
        return 'Paused';
    }
  }

  String _getWorkoutTypeText() {
    switch (workout.type) {
      case WorkoutType.strength:
        return 'Strength Training';
      case WorkoutType.cardio:
        return 'Cardio Workout';
      case WorkoutType.yoga:
        return 'Yoga Session';
      case WorkoutType.hiit:
        return 'HIIT Training';
      case WorkoutType.flexibility:
        return 'Flexibility';
      case WorkoutType.sports:
        return 'Sports Activity';
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;
  final Color? color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.theme,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? theme.colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: chipColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}