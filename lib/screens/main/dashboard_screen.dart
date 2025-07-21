import 'package:flutter/material.dart';
import 'package:pulseforge/widgets/gradient_container.dart';
import 'package:pulseforge/widgets/stats_card.dart';
import 'package:pulseforge/models/workout.dart';
import 'package:pulseforge/services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = '';
  List<WorkoutSession> todayWorkouts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await AuthService.instance.getCurrentUserWithProfile();
    setState(() {
      userName = user?.displayName ?? 'User';
      todayWorkouts = WorkoutData.getSampleWorkouts();
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
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good ${_getTimeOfDay()}!',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          Text(
                            userName,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Daily Stats
                Text(
                  "Today's Overview",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Calories',
                        value: '285',
                        unit: 'kcal',
                        icon: Icons.local_fire_department,
                        iconColor: Colors.orange,
                        subtitle: 'burned',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Active Time',
                        value: '45',
                        unit: 'min',
                        icon: Icons.timer,
                        iconColor: Colors.blue,
                        subtitle: 'today',
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Heart Rate',
                        value: '142',
                        unit: 'bpm',
                        icon: Icons.favorite,
                        iconColor: Colors.red,
                        subtitle: 'avg',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Streak',
                        value: '7',
                        unit: 'days',
                        icon: Icons.local_fire_department,
                        iconColor: Colors.green,
                        subtitle: 'current',
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Quick Actions
                Text(
                  'Quick Start',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        title: 'Start Workout',
                        subtitle: 'Begin your session',
                        icon: Icons.play_arrow,
                        gradient: [Colors.blue, Colors.purple],
                        onTap: () {},
                        theme: theme,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _QuickActionCard(
                        title: 'AI Coach',
                        subtitle: 'Get recommendations',
                        icon: Icons.psychology,
                        gradient: [Colors.green, Colors.teal],
                        onTap: () {},
                        theme: theme,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Upcoming Workouts
                Row(
                  children: [
                    Text(
                      'Upcoming Workouts',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See all',
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
                    itemCount: todayWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = todayWorkouts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _WorkoutCard(workout: workout, theme: theme),
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

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
  final ThemeData theme;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final WorkoutSession workout;
  final ThemeData theme;

  const _WorkoutCard({required this.workout, required this.theme});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    
    return Container(
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
                  '${workout.duration.inMinutes} min • ${_formatTime(workout.startTime)}',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
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

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}