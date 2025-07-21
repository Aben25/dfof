import 'package:flutter/material.dart';
import 'package:pulseforge/widgets/gradient_container.dart';
import 'package:pulseforge/widgets/custom_button.dart';
import 'package:pulseforge/models/user.dart';
import 'package:pulseforge/screens/onboarding/completion_screen.dart';

class HealthInfoScreen extends StatefulWidget {
  final FitnessGoal selectedGoal;
  final ActivityLevel selectedLevel;
  final List<WorkoutPreference> selectedPreferences;
  final Map<String, int> availability;

  const HealthInfoScreen({
    super.key,
    required this.selectedGoal,
    required this.selectedLevel,
    required this.selectedPreferences,
    required this.availability,
  });

  @override
  State<HealthInfoScreen> createState() => _HealthInfoScreenState();
}

class _HealthInfoScreenState extends State<HealthInfoScreen> {
  final _ageController = TextEditingController(text: '28');
  final _heightController = TextEditingController(text: '172');
  final _weightController = TextEditingController(text: '68');
  final _heartRateController = TextEditingController(text: '65');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _heartRateController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CompletionScreen(
            selectedGoal: widget.selectedGoal,
            selectedLevel: widget.selectedLevel,
            selectedPreferences: widget.selectedPreferences,
            availability: widget.availability,
            age: int.tryParse(_ageController.text),
            height: double.tryParse(_heightController.text),
            weight: double.tryParse(_weightController.text),
            restingHeartRate: int.tryParse(_heartRateController.text),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: GradientContainer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
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
                        '6/7',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    '👩‍⚕️',
                    style: theme.textTheme.displayLarge,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    "Basic health\ninformation",
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'This helps us personalize your workouts safely.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Age',
                                    hintText: 'Years',
                                    prefixIcon: Icon(Icons.cake, color: theme.colorScheme.primary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: theme.colorScheme.surface,
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      final age = int.tryParse(value);
                                      if (age == null || age < 13 || age > 100) {
                                        return 'Enter valid age (13-100)';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _heightController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Height',
                                    hintText: 'cm',
                                    prefixIcon: Icon(Icons.straighten, color: theme.colorScheme.primary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: theme.colorScheme.surface,
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      final height = double.tryParse(value);
                                      if (height == null || height < 100 || height > 250) {
                                        return 'Enter valid height';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _weightController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Weight',
                                    hintText: 'kg',
                                    prefixIcon: Icon(Icons.monitor_weight, color: theme.colorScheme.primary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: theme.colorScheme.surface,
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      final weight = double.tryParse(value);
                                      if (weight == null || weight < 30 || weight > 300) {
                                        return 'Enter valid weight';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _heartRateController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Resting HR',
                                    hintText: 'bpm',
                                    prefixIcon: Icon(Icons.favorite, color: theme.colorScheme.primary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: theme.colorScheme.surface,
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      final hr = int.tryParse(value);
                                      if (hr == null || hr < 40 || hr > 120) {
                                        return 'Enter valid HR (40-120)';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: theme.colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'All fields are optional. Skip any you prefer not to share.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  CustomButton(
                    text: 'Continue',
                    onPressed: _continue,
                    icon: Icons.arrow_forward,
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}