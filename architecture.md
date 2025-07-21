# PulseForge - AI-Powered Fitness App Architecture

## Overview
A modern AI-powered fitness app with Aura Ring-inspired design, featuring authentication, comprehensive onboarding, workout management, and AI-powered features.

## Core Features
1. **Authentication System** - Modern login/signup with email
2. **7-Screen Onboarding Flow** - Comprehensive fitness profile setup
3. **Main Dashboard** - Activity overview, stats, and insights
4. **Workout Management** - Session tracking, exercise library, and AI recommendations
5. **Profile Management** - User settings, progress tracking, and AI insights

## Technical Architecture

### Data Models
- `User` - User profile with fitness data
- `WorkoutSession` - Individual workout tracking
- `Exercise` - Exercise definitions and metadata
- `UserPreferences` - Fitness goals and preferences

### Screen Structure
1. **Authentication Flow**
   - `LoginScreen` - Modern login interface
   - `SignupScreen` - Account creation

2. **Onboarding Flow** (7 screens)
   - `WelcomeScreen` - App introduction
   - `FitnessGoalsScreen` - Primary fitness objectives
   - `ActivityLevelScreen` - Current fitness level
   - `PreferencesScreen` - Workout preferences
   - `ScheduleScreen` - Availability and timing
   - `HealthInfoScreen` - Basic health metrics
   - `CompletionScreen` - Setup completion

3. **Main App**
   - `MainNavigationScreen` - Bottom navigation wrapper
   - `DashboardScreen` - Home with stats and AI insights
   - `WorkoutScreen` - Active workout interface
   - `LibraryScreen` - Exercise library and routines
   - `ProfileScreen` - User profile and settings

### Component Structure
- **Reusable Widgets**
  - `CustomButton` - Styled buttons with loading states
  - `StatsCard` - Activity metrics display
  - `WorkoutCard` - Workout session preview
  - `ProgressIndicator` - Custom progress displays
  - `GradientContainer` - Modern gradient backgrounds

### State Management
- Local state with `StatefulWidget` and `setState`
- Shared preferences for user data persistence
- Simple service classes for business logic

### Color Theme (Aura-Ring Inspired)
- Primary: Deep purple/violet (#684F8E)
- Secondary: Soft grays and whites
- Accent: Gradient overlays and highlights
- Dark mode: Rich blacks with purple accents

## Implementation Priority
1. Authentication screens with modern UI
2. 7-screen onboarding flow with smooth animations
3. Main navigation and dashboard with stats cards
4. Workout management screens
5. Profile and settings
6. AI integration and polish

## File Structure
```
lib/
├── main.dart
├── theme.dart
├── models/
├── screens/
│   ├── auth/
│   ├── onboarding/
│   └── main/
├── widgets/
├── services/
└── utils/
```

## Key Design Principles
- Aura Ring-inspired minimalist aesthetic
- Smooth animations and transitions
- Card-based layouts with generous whitespace
- Gradient accents and modern typography
- AI-powered insights and recommendations