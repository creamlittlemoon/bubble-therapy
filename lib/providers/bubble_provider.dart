import 'package:flutter/material.dart';
import '../models/models.dart';

class BubbleProvider extends ChangeNotifier {
  final List<Bubble> _bubbles = [];
  int _dailyBubbleCount = 0;

  List<Bubble> get bubbles => _bubbles;
  List<Bubble> get unreleasedBubbles => 
    _bubbles.where((b) => !b.isReleased).toList();
  List<Bubble> get todaysBubbles => 
    _bubbles.where((b) => _isToday(b.createdAt)).toList();
  
  int get totalBubbles => _bubbles.length;
  int get releasedCount => _bubbles.where((b) => b.isReleased).length;
  int get pendingCount => unreleasedBubbles.length;
  int get dailyBubbleCount => _dailyBubbleCount;

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  void addBubble(String worry) {
    final bubble = Bubble(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      worry: worry,
      createdAt: DateTime.now(),
      size: 80 + (worry.length * 2).clamp(0, 40).toDouble(),
      posX: (100 + (_bubbles.length * 50) % 250).toDouble(),
      posY: (100 + (_bubbles.length * 30) % 300).toDouble(),
    );
    
    _bubbles.add(bubble);
    _dailyBubbleCount++;
    notifyListeners();
  }

  void releaseBubble(String id, {String? emotion}) {
    final index = _bubbles.indexWhere((b) => b.id == id);
    if (index != -1) {
      // Generate AI reflection (simplified)
      final reflection = _generateReflection(_bubbles[index].worry, emotion);
      
      _bubbles[index] = _bubbles[index].copyWith(
        isReleased: true,
        reflection: reflection,
        emotion: emotion,
      );
      notifyListeners();
    }
  }

  void popBubble(String id) {
    final index = _bubbles.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bubbles.removeAt(index);
      notifyListeners();
    }
  }

  String _generateReflection(String worry, String? emotion) {
    // Simplified reflection generation
    final reflections = [
      'It\'s okay to feel this way. Every worry released makes space for peace.',
      'You\'re doing great. Acknowledging your feelings is the first step toward healing.',
      'This too shall pass. Your strength is greater than this moment.',
      'Take a deep breath. You\'ve carried this long enough—time to let it float away.',
      'Your feelings are valid. Thank you for trusting this bubble with them.',
    ];
    
    if (emotion != null) {
      final emotionReflections = {
        'anxious': 'Anxiety is just a visitor, not a resident. Let it pass through.',
        'sad': 'It\'s okay to not be okay. Your sadness is part of your healing.',
        'angry': 'Anger often masks deeper feelings. You\'re brave for acknowledging it.',
        'stressed': 'Take a moment to breathe. You don\'t have to carry everything at once.',
        'tired': 'Rest is productive. You deserve to recharge.',
      };
      return emotionReflections[emotion.toLowerCase()] ?? reflections[0];
    }
    
    return reflections[DateTime.now().millisecond % reflections.length];
  }

  void resetDailyCount() {
    _dailyBubbleCount = 0;
    notifyListeners();
  }

  void drainAllBubbles() {
    for (var i = 0; i < _bubbles.length; i++) {
      if (!_bubbles[i].isReleased) {
        _bubbles[i] = _bubbles[i].copyWith(
          isReleased: true,
          reflection: 'Released during night ritual.',
        );
      }
    }
    notifyListeners();
  }
}
