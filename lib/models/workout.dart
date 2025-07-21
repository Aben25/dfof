class WorkoutSession {
  final String id;
  final String name;
  final WorkoutType type;
  final Duration duration;
  final List<Exercise> exercises;
  final DateTime startTime;
  final DateTime? endTime;
  final WorkoutStatus status;
  final int? caloriesBurned;
  final double? intensityScore;

  WorkoutSession({
    required this.id,
    required this.name,
    required this.type,
    required this.duration,
    required this.exercises,
    required this.startTime,
    this.endTime,
    this.status = WorkoutStatus.planned,
    this.caloriesBurned,
    this.intensityScore,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'duration': duration.inMinutes,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'status': status.name,
    'caloriesBurned': caloriesBurned,
    'intensityScore': intensityScore,
  };

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => WorkoutSession(
    id: json['id'],
    name: json['name'],
    type: WorkoutType.values.firstWhere((t) => t.name == json['type']),
    duration: Duration(minutes: json['duration']),
    exercises: (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
    startTime: DateTime.parse(json['startTime']),
    endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    status: WorkoutStatus.values.firstWhere((s) => s.name == json['status']),
    caloriesBurned: json['caloriesBurned'],
    intensityScore: json['intensityScore']?.toDouble(),
  );
}

class Exercise {
  final String id;
  final String name;
  final String description;
  final ExerciseType type;
  final String? imageUrl;
  final List<ExerciseSet> sets;
  final String? instructions;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.imageUrl,
    required this.sets,
    this.instructions,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type.name,
    'imageUrl': imageUrl,
    'sets': sets.map((s) => s.toJson()).toList(),
    'instructions': instructions,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    type: ExerciseType.values.firstWhere((t) => t.name == json['type']),
    imageUrl: json['imageUrl'],
    sets: (json['sets'] as List).map((s) => ExerciseSet.fromJson(s)).toList(),
    instructions: json['instructions'],
  );
}

class ExerciseSet {
  final int reps;
  final double? weight;
  final Duration? duration;
  final bool completed;

  ExerciseSet({
    required this.reps,
    this.weight,
    this.duration,
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
    'reps': reps,
    'weight': weight,
    'duration': duration?.inSeconds,
    'completed': completed,
  };

  factory ExerciseSet.fromJson(Map<String, dynamic> json) => ExerciseSet(
    reps: json['reps'],
    weight: json['weight']?.toDouble(),
    duration: json['duration'] != null ? Duration(seconds: json['duration']) : null,
    completed: json['completed'],
  );
}

enum WorkoutType { strength, cardio, yoga, hiit, flexibility, sports }
enum ExerciseType { strength, cardio, flexibility, balance }
enum WorkoutStatus { planned, active, completed, paused }

// Sample workout data
class WorkoutData {
  static List<WorkoutSession> getSampleWorkouts() => [
    WorkoutSession(
      id: '1',
      name: 'Morning HIIT Blast',
      type: WorkoutType.hiit,
      duration: const Duration(minutes: 30),
      startTime: DateTime.now().subtract(const Duration(hours: 2)),
      status: WorkoutStatus.completed,
      caloriesBurned: 285,
      intensityScore: 8.5,
      exercises: [
        Exercise(
          id: 'e1',
          name: 'Burpees',
          description: 'Full body explosive movement',
          type: ExerciseType.cardio,
          sets: [ExerciseSet(reps: 10, completed: true)],
        ),
        Exercise(
          id: 'e2',
          name: 'Mountain Climbers',
          description: 'Core and cardio combination',
          type: ExerciseType.cardio,
          sets: [ExerciseSet(reps: 20, completed: true)],
        ),
      ],
    ),
    WorkoutSession(
      id: '2',
      name: 'Upper Body Strength',
      type: WorkoutType.strength,
      duration: const Duration(minutes: 45),
      startTime: DateTime.now().add(const Duration(hours: 2)),
      status: WorkoutStatus.planned,
      exercises: [
        Exercise(
          id: 'e3',
          name: 'Push-ups',
          description: 'Upper body pressing movement',
          type: ExerciseType.strength,
          sets: [
            ExerciseSet(reps: 12),
            ExerciseSet(reps: 10),
            ExerciseSet(reps: 8),
          ],
        ),
      ],
    ),
    WorkoutSession(
      id: '3',
      name: 'Evening Yoga Flow',
      type: WorkoutType.yoga,
      duration: const Duration(minutes: 25),
      startTime: DateTime.now().add(const Duration(hours: 8)),
      status: WorkoutStatus.planned,
      exercises: [
        Exercise(
          id: 'e4',
          name: 'Sun Salutation',
          description: 'Traditional yoga sequence',
          type: ExerciseType.flexibility,
          sets: [ExerciseSet(reps: 5)],
        ),
      ],
    ),
  ];
}