import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pulseforge/config/supabase_config.dart';
import 'package:pulseforge/models/user.dart' as app_models;
import 'package:uuid/uuid.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();
  AuthService._();

  SupabaseClient get _supabase => SupabaseConfig.client;
  final _uuid = const Uuid();

  // Stream to listen to auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Check if user is currently logged in
  bool get isLoggedIn => _supabase.auth.currentUser != null;

  // Get current auth user
  app_models.User? get currentAuthUser {
    final authUser = _supabase.auth.currentUser;
    if (authUser != null) {
      return app_models.User(
        id: authUser.id,
        email: authUser.email ?? '',
        displayName: authUser.userMetadata?['display_name'],
        avatarUrl: authUser.userMetadata?['avatar_url'],
        createdAt: DateTime.parse(authUser.createdAt),
        updatedAt: DateTime.parse(authUser.updatedAt ?? authUser.createdAt),
      );
    }
    return null;
  }

  Future<AuthResponse> signup(String email, String password, {String? displayName}) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );

      // If signup successful and user is created, create user record in public.users table
      if (response.user != null) {
        await _createUserRecord(response.user!);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Create user record in public.users table
  Future<void> _createUserRecord(User user) async {
    try {
      await _supabase.from('users').insert({
        'id': user.id,
        'email': user.email,
        'display_name': user.userMetadata?['display_name'],
        'avatar_url': user.userMetadata?['avatar_url'],
      });
    } catch (e) {
      debugPrint('Error creating user record: $e');
      // Don't rethrow as this is not critical for auth
    }
  }

  // Get user profile from database
  Future<app_models.UserProfile?> getUserProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        return app_models.UserProfile.fromJson(response);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return null;
    }
  }

  // Create or update user profile
  Future<app_models.UserProfile?> createOrUpdateUserProfile({
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
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      // Check if profile exists
      final existingProfile = await getUserProfile();
      
      final profileData = {
        'user_id': userId,
        'full_name': fullName,
        'gender': gender,
        'age': age,
        'height': height,
        'weight': weight,
        'height_unit': heightUnit ?? 'cm',
        'weight_unit': weightUnit ?? 'kg',
        'fitness_goals': fitnessGoals ?? [],
        'fitness_priorities': fitnessPriorities ?? [],
        'additional_info': additionalInfo,
        'fitness_level': fitnessLevel,
        'exercise_preferences': exercisePreferences ?? [],
        'workout_frequency': workoutFrequency,
        'workout_duration': workoutDuration,
        'preferred_days': preferredDays ?? [],
        'onboarding_completed': onboardingCompleted ?? false,
        'updated_at': DateTime.now().toIso8601String(),
      };

      Map<String, dynamic> response;
      
      if (existingProfile != null) {
        // Update existing profile
        response = await _supabase
            .from('user_profiles')
            .update(profileData)
            .eq('user_id', userId)
            .select()
            .single();
      } else {
        // Create new profile
        profileData['id'] = _uuid.v4();
        profileData['created_at'] = DateTime.now().toIso8601String();
        
        response = await _supabase
            .from('user_profiles')
            .insert(profileData)
            .select()
            .single();
      }

      return app_models.UserProfile.fromJson(response);
    } catch (e) {
      debugPrint('Error creating/updating user profile: $e');
      rethrow;
    }
  }

  // Get current user with profile
  Future<app_models.User?> getCurrentUserWithProfile() async {
    try {
      final authUser = currentAuthUser;
      if (authUser == null) return null;

      final profile = await getUserProfile();
      return authUser.copyWith(profile: profile);
    } catch (e) {
      debugPrint('Error getting current user with profile: $e');
      return currentAuthUser;
    }
  }
}