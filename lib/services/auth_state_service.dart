import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pulseforge/config/supabase_config.dart';
import 'package:pulseforge/models/user.dart' as app_models;
import 'package:pulseforge/services/auth_service.dart';

enum AuthStatus {
  uninitialized,
  unauthenticated,
  authenticating,
  authenticated,
  onboardingRequired,
}

class AuthStateService extends ChangeNotifier {
  static AuthStateService? _instance;
  static AuthStateService get instance => _instance ??= AuthStateService._();
  AuthStateService._() {
    _initialize();
  }

  AuthStatus _status = AuthStatus.uninitialized;
  app_models.User? _user;
  app_models.UserProfile? _userProfile;
  StreamSubscription<AuthState>? _authSubscription;

  // Getters
  AuthStatus get status => _status;
  app_models.User? get user => _user;
  app_models.UserProfile? get userProfile => _userProfile;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get needsOnboarding => _status == AuthStatus.onboardingRequired;
  bool get isLoading => _status == AuthStatus.authenticating || _status == AuthStatus.uninitialized;

  SupabaseClient get _supabase => SupabaseConfig.client;

  void _initialize() {
    // Listen to auth state changes
    _authSubscription = _supabase.auth.onAuthStateChange.listen(_onAuthStateChange);
    
    // Check initial auth state
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session?.user != null) {
        await _handleUserAuthenticated(session!.user);
      } else {
        _updateStatus(AuthStatus.unauthenticated);
      }
    } catch (e) {
      debugPrint('Error checking initial auth: $e');
      _updateStatus(AuthStatus.unauthenticated);
    }
  }

  void _onAuthStateChange(AuthState authState) async {
    debugPrint('Auth state changed: ${authState.event}');
    
    switch (authState.event) {
      case AuthChangeEvent.signedIn:
        if (authState.session?.user != null) {
          await _handleUserAuthenticated(authState.session!.user);
        }
        break;
      case AuthChangeEvent.signedOut:
        _handleUserSignedOut();
        break;
      case AuthChangeEvent.tokenRefreshed:
        // Session refreshed, user is still authenticated
        break;
      case AuthChangeEvent.userUpdated:
        if (authState.session?.user != null) {
          await _handleUserAuthenticated(authState.session!.user);
        }
        break;
      case AuthChangeEvent.passwordRecovery:
        // Handle password recovery if needed
        break;
      case AuthChangeEvent.initialSession:
        // Handle initial session if needed
        break;
      case AuthChangeEvent.mfaChallengeVerified:
        // Handle MFA challenge verification if needed
        break;
      // ignore: deprecated_member_use
      case AuthChangeEvent.userDeleted:
        _handleUserSignedOut();
        break;
    }
  }

  Future<void> _handleUserAuthenticated(User authUser) async {
    try {
      _updateStatus(AuthStatus.authenticating);
      
      // Create User object
      _user = app_models.User(
        id: authUser.id,
        email: authUser.email ?? '',
        displayName: authUser.userMetadata?['display_name'],
        avatarUrl: authUser.userMetadata?['avatar_url'],
        createdAt: DateTime.parse(authUser.createdAt),
        updatedAt: DateTime.parse(authUser.updatedAt ?? authUser.createdAt),
      );

      // Check if user profile exists and if onboarding is completed
      _userProfile = await AuthService.instance.getUserProfile();
      
      if (_userProfile?.onboardingCompleted == true) {
        _updateStatus(AuthStatus.authenticated);
      } else {
        _updateStatus(AuthStatus.onboardingRequired);
      }
    } catch (e) {
      debugPrint('Error handling user authentication: $e');
      _updateStatus(AuthStatus.unauthenticated);
    }
  }

  void _handleUserSignedOut() {
    _user = null;
    _userProfile = null;
    _updateStatus(AuthStatus.unauthenticated);
  }

  void _updateStatus(AuthStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;
      debugPrint('Auth status updated: $newStatus');
      notifyListeners();
    }
  }

  // Method to refresh user profile (call after onboarding completion)
  Future<void> refreshUserProfile() async {
    try {
      if (_user != null) {
        _userProfile = await AuthService.instance.getUserProfile();
        
        if (_userProfile?.onboardingCompleted == true) {
          _updateStatus(AuthStatus.authenticated);
        } else {
          _updateStatus(AuthStatus.onboardingRequired);
        }
      }
    } catch (e) {
      debugPrint('Error refreshing user profile: $e');
    }
  }

  // Method to sign out
  Future<void> signOut() async {
    try {
      await AuthService.instance.logout();
      // _handleUserSignedOut will be called by the auth state listener
    } catch (e) {
      debugPrint('Error signing out: $e');
      // Force local sign out even if server call fails
      _handleUserSignedOut();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}