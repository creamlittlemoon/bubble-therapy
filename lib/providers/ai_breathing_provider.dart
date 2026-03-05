import 'dart:math';
import 'package:flutter/foundation.dart';

enum BreathingPattern {
  calm,
  focus,
  sleep,
  energy,
  stressRelief,
}

class BreathingConfig {
  final String name;
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final int holdEmptySeconds;
  final String description;
  final ColorTheme theme;

  BreathingConfig({
    required this.name,
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
    required this.holdEmptySeconds,
    required this.description,
    required this.theme,
  });
}

class ColorTheme {
  final Color primary;
  final Color secondary;
  final Color background;

  ColorTheme({
    required this.primary,
    required this.secondary,
    required this.background,
  });
}

class AIBreathingProvider extends ChangeNotifier {
  // AI Recommended Pattern
  BreathingPattern _currentPattern = BreathingPattern.calm;
  int _sessionDuration = 5; // minutes
  bool _isPlaying = false;
  String _phase = 'ready'; // ready, inhale, hold, exhale, hold_empty
  double _progress = 0.0;
  
  // User Stats
  int _totalSessions = 0;
  int _totalMinutes = 0;
  int _currentStreak = 0;
  
  // AI Analysis
  String? _aiRecommendation;
  double _stressLevel = 0.5; // 0.0 - 1.0
  
  // Getters
  BreathingPattern get currentPattern => _currentPattern;
  int get sessionDuration => _sessionDuration;
  bool get isPlaying => _isPlaying;
  String get phase => _phase;
  double get progress => _progress;
  int get totalSessions => _totalSessions;
  int get totalMinutes => _totalMinutes;
  int get currentStreak => _currentStreak;
  String? get aiRecommendation => _aiRecommendation;
  double get stressLevel => _stressLevel;
  
  // Breathing Patterns Config
  final Map<BreathingPattern, BreathingConfig> _patterns = {
    BreathingPattern.calm: BreathingConfig(
      name: 'Calm Breathing',
      inhaleSeconds: 4,
      holdSeconds: 4,
      exhaleSeconds: 4,
      holdEmptySeconds: 0,
      description: 'Box breathing for instant calm',
      theme: ColorTheme(
        primary: const Color(0xFF7C9D96),
        secondary: const Color(0xFF9CAF88),
        background: const Color(0xFFE8F0EE),
      ),
    ),
    BreathingPattern.focus: BreathingConfig(
      name: 'Focus Flow',
      inhaleSeconds: 4,
      holdSeconds: 2,
      exhaleSeconds: 6,
      holdEmptySeconds: 0,
      description: 'Enhance concentration and clarity',
      theme: ColorTheme(
        primary: const Color(0xFF5B7B99),
        secondary: const Color(0xFF8BA4BE),
        background: const Color(0xFFE8EEF3),
      ),
    ),
    BreathingPattern.sleep: BreathingConfig(
      name: 'Deep Sleep',
      inhaleSeconds: 4,
      holdSeconds: 7,
      exhaleSeconds: 8,
      holdEmptySeconds: 0,
      description: '4-7-8 technique for better sleep',
      theme: ColorTheme(
        primary: const Color(0xFF6B5B95),
        secondary: const Color(0xFF9B8BC5),
        background: const Color(0xFFEDEAF3),
      ),
    ),
    BreathingPattern.energy: BreathingConfig(
      name: 'Energy Boost',
      inhaleSeconds: 2,
      holdSeconds: 0,
      exhaleSeconds: 2,
      holdEmptySeconds: 0,
      description: 'Quick energizing breaths',
      theme: ColorTheme(
        primary: const Color(0xFFE07B39),
        secondary: const Color(0xFFF0A070),
        background: const Color(0xFFFDF0E8),
      ),
    ),
    BreathingPattern.stressRelief: BreathingConfig(
      name: 'Stress Relief',
      inhaleSeconds: 4,
      holdSeconds: 2,
      exhaleSeconds: 6,
      holdEmptySeconds: 2,
      description: 'Release tension and anxiety',
      theme: ColorTheme(
        primary: const Color(0xFF7C9D96),
        secondary: const Color(0xFFB8D4CE),
        background: const Color(0xFFE8F2F0),
      ),
    ),
  };
  
  BreathingConfig get currentConfig => _patterns[_currentPattern]!;
  
  // AI Methods
  void analyzeStressLevel(double heartRate, String mood) {
    // Simulate AI analysis
    double baseStress = 0.5;
    
    if (heartRate > 80) baseStress += 0.2;
    if (heartRate > 100) baseStress += 0.2;
    
    if (mood.contains('anxious') || mood.contains('stressed')) {
      baseStress += 0.2;
    }
    if (mood.contains('calm') || mood.contains('relaxed')) {
      baseStress -= 0.2;
    }
    
    _stressLevel = baseStress.clamp(0.0, 1.0);
    
    // AI Recommendation
    _recommendPattern();
    notifyListeners();
  }
  
  void _recommendPattern() {
    if (_stressLevel > 0.7) {
      _currentPattern = BreathingPattern.stressRelief;
      _aiRecommendation = 'High stress detected. Try Stress Relief breathing.';
    } else if (_stressLevel > 0.4) {
      _currentPattern = BreathingPattern.calm;
      _aiRecommendation = 'Moderate stress. Calm breathing recommended.';
    } else {
      _currentPattern = BreathingPattern.focus;
      _aiRecommendation = 'You\'re doing well! Try Focus Flow for productivity.';
    }
  }
  
  void setPattern(BreathingPattern pattern) {
    _currentPattern = pattern;
    _aiRecommendation = null;
    notifyListeners();
  }
  
  void setDuration(int minutes) {
    _sessionDuration = minutes;
    notifyListeners();
  }
  
  void startSession() {
    _isPlaying = true;
    _phase = 'inhale';
    _progress = 0.0;
    notifyListeners();
    _runBreathingCycle();
  }
  
  void pauseSession() {
    _isPlaying = false;
    notifyListeners();
  }
  
  void stopSession() {
    _isPlaying = false;
    _phase = 'ready';
    _progress = 0.0;
    _totalSessions++;
    _totalMinutes += _sessionDuration;
    notifyListeners();
  }
  
  void _runBreathingCycle() async {
    while (_isPlaying) {
      final config = currentConfig;
      
      // Inhale
      _phase = 'inhale';
      await _animatePhase(config.inhaleSeconds);
      if (!_isPlaying) break;
      
      // Hold
      if (config.holdSeconds > 0) {
        _phase = 'hold';
        await _animatePhase(config.holdSeconds);
        if (!_isPlaying) break;
      }
      
      // Exhale
      _phase = 'exhale';
      await _animatePhase(config.exhaleSeconds);
      if (!_isPlaying) break;
      
      // Hold Empty
      if (config.holdEmptySeconds > 0) {
        _phase = 'hold_empty';
        await _animatePhase(config.holdEmptySeconds);
      }
    }
  }
  
  Future<void> _animatePhase(int seconds) async {
    final steps = seconds * 10;
    for (int i = 0; i <= steps; i++) {
      if (!_isPlaying) break;
      _progress = i / steps;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
  
  void updateProgress(double value) {
    _progress = value;
    notifyListeners();
  }
}

// Extension for Color
class Color {
  final int value;
  const Color(this.value);
  
  static const transparent = Color(0x00000000);
}
