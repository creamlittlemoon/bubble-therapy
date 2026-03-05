import 'dart:math';
import 'package:flutter/foundation.dart';

enum MoodType {
  amazing,
  good,
  okay,
  stressed,
  anxious,
  tired,
}

class MoodEntry {
  final String id;
  final MoodType mood;
  final String? note;
  final DateTime timestamp;
  final List<String> tags;
  final double? stressLevel;

  MoodEntry({
    required this.id,
    required this.mood,
    this.note,
    required this.timestamp,
    this.tags = const [],
    this.stressLevel,
  });
}

class MoodProvider extends ChangeNotifier {
  MoodType? _currentMood;
  String? _currentNote;
  final List<MoodEntry> _moodHistory = [];
  List<String> _selectedTags = [];
  
  // AI Analysis Results
  String? _aiInsight;
  List<String> _aiSuggestions = [];
  Map<String, double> _moodTrends = {};
  
  // Getters
  MoodType? get currentMood => _currentMood;
  String? get currentNote => _currentNote;
  List<MoodEntry> get moodHistory => _moodHistory;
  List<String> get selectedTags => _selectedTags;
  String? get aiInsight => _aiInsight;
  List<String> get aiSuggestions => _aiSuggestions;
  Map<String, double> get moodTrends => _moodTrends;
  
  // Available tags for mood context
  final List<String> _availableTags = [
    'Work',
    'Sleep',
    'Exercise',
    'Social',
    'Family',
    'Health',
    'Weather',
    'Caffeine',
  ];
  
  List<String> get availableTags => _availableTags;
  
  void setMood(MoodType mood) {
    _currentMood = mood;
    _analyzeMood();
    notifyListeners();
  }
  
  void setNote(String note) {
    _currentNote = note;
    notifyListeners();
  }
  
  void toggleTag(String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    _analyzeMood();
    notifyListeners();
  }
  
  void saveMoodEntry() {
    if (_currentMood == null) return;
    
    final entry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mood: _currentMood!,
      note: _currentNote,
      timestamp: DateTime.now(),
      tags: List.from(_selectedTags),
      stressLevel: _calculateStressLevel(),
    );
    
    _moodHistory.insert(0, entry);
    _generateAIInsights();
    
    // Reset current selection
    _currentMood = null;
    _currentNote = null;
    _selectedTags = [];
    
    notifyListeners();
  }
  
  double _calculateStressLevel() {
    if (_currentMood == null) return 0.5;
    
    switch (_currentMood!) {
      case MoodType.amazing:
        return 0.1;
      case MoodType.good:
        return 0.2;
      case MoodType.okay:
        return 0.4;
      case MoodType.tired:
        return 0.5;
      case MoodType.stressed:
        return 0.7;
      case MoodType.anxious:
        return 0.9;
    }
  }
  
  void _analyzeMood() {
    // Simulate AI mood analysis
    if (_currentMood == null) return;
    
    final stress = _calculateStressLevel();
    
    if (stress > 0.6) {
      _aiSuggestions = [
        'Try a 5-minute breathing exercise',
        'Take a short walk outside',
        'Listen to calming music',
      ];
    } else if (stress > 0.3) {
      _aiSuggestions = [
        'Consider a brief meditation',
        'Practice gratitude journaling',
      ];
    } else {
      _aiSuggestions = [
        'Great mood! Keep it up',
        'Share your positive energy',
      ];
    }
    
    notifyListeners();
  }
  
  void _generateAIInsights() {
    // Simulate AI insight generation based on history
    if (_moodHistory.length < 3) {
      _aiInsight = 'Keep tracking your mood to see personalized insights.';
      return;
    }
    
    // Calculate trends
    final recentMoods = _moodHistory.take(7).toList();
    final avgStress = recentMoods
        .map((e) => e.stressLevel ?? 0.5)
        .reduce((a, b) => a + b) / recentMoods.length;
    
    if (avgStress > 0.6) {
      _aiInsight = 'Your stress levels have been elevated this week. Consider increasing your daily breathing practice.';
    } else if (avgStress < 0.3) {
      _aiInsight = 'You\'re maintaining great emotional balance! Your current routine is working well.';
    } else {
      _aiInsight = 'Your mood has been stable. Try varying your wellness activities for added benefits.';
    }
    
    // Update trends
    _updateMoodTrends();
  }
  
  void _updateMoodTrends() {
    _moodTrends = {};
    
    for (var entry in _moodHistory.take(7)) {
      final day = '${entry.timestamp.month}/${entry.timestamp.day}';
      _moodTrends[day] = 1 - (entry.stressLevel ?? 0.5); // Convert to wellness score
    }
  }
  
  String getMoodEmoji(MoodType mood) {
    switch (mood) {
      case MoodType.amazing:
        return '😄';
      case MoodType.good:
        return '🙂';
      case MoodType.okay:
        return '😐';
      case MoodType.tired:
        return '😴';
      case MoodType.stressed:
        return '😰';
      case MoodType.anxious:
        return '😟';
    }
  }
  
  String getMoodLabel(MoodType mood) {
    switch (mood) {
      case MoodType.amazing:
        return 'Amazing';
      case MoodType.good:
        return 'Good';
      case MoodType.okay:
        return 'Okay';
      case MoodType.tired:
        return 'Tired';
      case MoodType.stressed:
        return 'Stressed';
      case MoodType.anxious:
        return 'Anxious';
    }
  }
  
  Color getMoodColor(MoodType mood) {
    switch (mood) {
      case MoodType.amazing:
        return const Color(0xFF4CAF50);
      case MoodType.good:
        return const Color(0xFF8BC34A);
      case MoodType.okay:
        return const Color(0xFFFFC107);
      case MoodType.tired:
        return const Color(0xFF9E9E9E);
      case MoodType.stressed:
        return const Color(0xFFFF9800);
      case MoodType.anxious:
        return const Color(0xFFF44336);
    }
  }
}

class Color {
  final int value;
  const Color(this.value);
}
