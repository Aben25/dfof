class User {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserProfile? profile;

  User({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    this.profile,
  });

  String get name => displayName ?? email.split('@').first;

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'display_name': displayName,
    'avatar_url': avatarUrl,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    displayName: json['display_name'],
    avatarUrl: json['avatar_url'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserProfile? profile,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    displayName: displayName ?? this.displayName,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    profile: profile ?? this.profile,
  );
}

class UserProfile {
  final String id;
  final String userId;
  final String? fullName;
  final String? gender;
  final int? age;
  final double? height;
  final double? weight;
  final String heightUnit;
  final String weightUnit;
  final List<String> fitnessGoals;
  final List<String> fitnessPriorities;
  final String? additionalInfo;
  final String? fitnessLevel;
  final List<String> exercisePreferences;
  final int? workoutFrequency;
  final int? workoutDuration;
  final List<String> preferredDays;
  final bool onboardingCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.userId,
    this.fullName,
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.heightUnit = 'cm',
    this.weightUnit = 'kg',
    this.fitnessGoals = const [],
    this.fitnessPriorities = const [],
    this.additionalInfo,
    this.fitnessLevel,
    this.exercisePreferences = const [],
    this.workoutFrequency,
    this.workoutDuration,
    this.preferredDays = const [],
    this.onboardingCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'full_name': fullName,
    'gender': gender,
    'age': age,
    'height': height,
    'weight': weight,
    'height_unit': heightUnit,
    'weight_unit': weightUnit,
    'fitness_goals': fitnessGoals,
    'fitness_priorities': fitnessPriorities,
    'additional_info': additionalInfo,
    'fitness_level': fitnessLevel,
    'exercise_preferences': exercisePreferences,
    'workout_frequency': workoutFrequency,
    'workout_duration': workoutDuration,
    'preferred_days': preferredDays,
    'onboarding_completed': onboardingCompleted,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'],
    userId: json['user_id'],
    fullName: json['full_name'],
    gender: json['gender'],
    age: json['age'],
    height: json['height']?.toDouble(),
    weight: json['weight']?.toDouble(),
    heightUnit: json['height_unit'] ?? 'cm',
    weightUnit: json['weight_unit'] ?? 'kg',
    fitnessGoals: List<String>.from(json['fitness_goals'] ?? []),
    fitnessPriorities: List<String>.from(json['fitness_priorities'] ?? []),
    additionalInfo: json['additional_info'],
    fitnessLevel: json['fitness_level'],
    exercisePreferences: List<String>.from(json['exercise_preferences'] ?? []),
    workoutFrequency: json['workout_frequency'],
    workoutDuration: json['workout_duration'],
    preferredDays: List<String>.from(json['preferred_days'] ?? []),
    onboardingCompleted: json['onboarding_completed'] ?? false,
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  UserProfile copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? gender,
    int? age,
    double? height,
    double? weight,
    String? heightUnit,
    String? weightUnit,
    List<String>? fitnessGoals,
    List<String>? fitnessPriorities,
    String? additionalInfo,
    String? fitnessLevel,
    List<String>? exercisePreferences,
    int? workoutFrequency,
    int? workoutDuration,
    List<String>? preferredDays,
    bool? onboardingCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserProfile(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    fullName: fullName ?? this.fullName,
    gender: gender ?? this.gender,
    age: age ?? this.age,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    heightUnit: heightUnit ?? this.heightUnit,
    weightUnit: weightUnit ?? this.weightUnit,
    fitnessGoals: fitnessGoals ?? this.fitnessGoals,
    fitnessPriorities: fitnessPriorities ?? this.fitnessPriorities,
    additionalInfo: additionalInfo ?? this.additionalInfo,
    fitnessLevel: fitnessLevel ?? this.fitnessLevel,
    exercisePreferences: exercisePreferences ?? this.exercisePreferences,
    workoutFrequency: workoutFrequency ?? this.workoutFrequency,
    workoutDuration: workoutDuration ?? this.workoutDuration,
    preferredDays: preferredDays ?? this.preferredDays,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

// Legacy enums for backward compatibility
enum FitnessGoal { weightLoss, muscleGain, endurance, strength, flexibility, general }
enum ActivityLevel { beginner, intermediate, advanced }
enum WorkoutPreference { cardio, strength, yoga, pilates, hiit, outdoor, home }

// Constants for new string-based values
class FitnessGoals {
  static const String weightLoss = 'weightLoss';
  static const String muscleGain = 'muscleGain';
  static const String endurance = 'endurance';
  static const String strength = 'strength';
  static const String flexibility = 'flexibility';
  static const String general = 'general';
}

class FitnessLevels {
  static const String beginner = 'beginner';
  static const String intermediate = 'intermediate';
  static const String advanced = 'advanced';
}

class ExercisePreferences {
  static const String cardio = 'cardio';
  static const String strength = 'strength';
  static const String yoga = 'yoga';
  static const String pilates = 'pilates';
  static const String hiit = 'hiit';
  static const String outdoor = 'outdoor';
  static const String home = 'home';
}

class Genders {
  static const String male = 'male';
  static const String female = 'female';
  static const String other = 'other';
  static const String preferNotToSay = 'preferNotToSay';
}