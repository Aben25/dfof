class User {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;
  final UserProfile? profile;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    this.profile,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'profile': profile?.toJson(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    createdAt: DateTime.parse(json['createdAt']),
    profile: json['profile'] != null ? UserProfile.fromJson(json['profile']) : null,
  );
}

class UserProfile {
  final FitnessGoal goal;
  final ActivityLevel activityLevel;
  final List<WorkoutPreference> preferences;
  final Map<String, int> availability;
  final HealthMetrics healthMetrics;
  final bool onboardingCompleted;

  UserProfile({
    required this.goal,
    required this.activityLevel,
    required this.preferences,
    required this.availability,
    required this.healthMetrics,
    this.onboardingCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'goal': goal.name,
    'activityLevel': activityLevel.name,
    'preferences': preferences.map((p) => p.name).toList(),
    'availability': availability,
    'healthMetrics': healthMetrics.toJson(),
    'onboardingCompleted': onboardingCompleted,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    goal: FitnessGoal.values.firstWhere((g) => g.name == json['goal']),
    activityLevel: ActivityLevel.values.firstWhere((a) => a.name == json['activityLevel']),
    preferences: (json['preferences'] as List).map((p) => WorkoutPreference.values.firstWhere((w) => w.name == p)).toList(),
    availability: Map<String, int>.from(json['availability']),
    healthMetrics: HealthMetrics.fromJson(json['healthMetrics']),
    onboardingCompleted: json['onboardingCompleted'] ?? false,
  );
}

enum FitnessGoal { weightLoss, muscleGain, endurance, strength, flexibility, general }

enum ActivityLevel { beginner, intermediate, advanced }

enum WorkoutPreference { cardio, strength, yoga, pilates, hiit, outdoor, home }

class HealthMetrics {
  final int? age;
  final double? height;
  final double? weight;
  final int? restingHeartRate;

  HealthMetrics({this.age, this.height, this.weight, this.restingHeartRate});

  Map<String, dynamic> toJson() => {
    'age': age,
    'height': height,
    'weight': weight,
    'restingHeartRate': restingHeartRate,
  };

  factory HealthMetrics.fromJson(Map<String, dynamic> json) => HealthMetrics(
    age: json['age'],
    height: json['height']?.toDouble(),
    weight: json['weight']?.toDouble(),
    restingHeartRate: json['restingHeartRate'],
  );
}