import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class BubbleProvider extends ChangeNotifier {
  final List<Bubble> _bubbles = [];
  int _dailyBubbleCount = 0;
  StorageService? _storage;

  List<Bubble> get bubbles => _bubbles;
  List<Bubble> get unreleasedBubbles => 
    _bubbles.where((b) => !b.isReleased).toList();
  List<Bubble> get todaysBubbles => 
    _bubbles.where((b) => _isToday(b.createdAt)).toList();
  
  int get totalBubbles => _bubbles.length;
  int get releasedCount => _bubbles.where((b) => b.isReleased).length;
  int get pendingCount => unreleasedBubbles.length;
  int get dailyBubbleCount => _dailyBubbleCount;

  void setStorage(StorageService? storage) {
    _storage = storage;
  }

  void setBubbles(List<Bubble> bubbles) {
    _bubbles.clear();
    _bubbles.addAll(bubbles);
    _dailyBubbleCount = bubbles.where((b) => _isToday(b.createdAt)).length;
    notifyListeners();
  }

  Future<void> _persistBubbles() async {
    await _storage?.saveBubbles(_bubbles);
  }

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
    _persistBubbles();
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
      _persistBubbles();
    }
  }

  void popBubble(String id) {
    final index = _bubbles.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bubbles.removeAt(index);
      notifyListeners();
      _persistBubbles();
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
    _persistBubbles();
  }

  /// Seeds 5–8 demo bubbles (multiple emotions, intensities, last 3 days).
  /// Returns the list of released bubbles so caller can add stars.
  List<Bubble> seedDemoData() {
    final now = DateTime.now();
    final releasedReflections = [
      'It\'s okay to feel this way. Every worry released makes space for peace.',
      'You\'re doing great. Acknowledging your feelings is the first step.',
    ];
    final emotions = ['anxious', 'sad', 'stressed', 'tired', 'angry'];
    final demoBubbles = <Bubble>[
      // 2 released (3 days ago, 2 days ago)
      Bubble(
        id: 'demo_1',
        worry: 'Meeting deadline at work',
        createdAt: now.subtract(const Duration(days: 3)),
        isReleased: true,
        reflection: releasedReflections[0],
        emotion: 'stressed',
        size: 100,
        posX: 120,
        posY: 180,
      ),
      Bubble(
        id: 'demo_2',
        worry: 'Feeling disconnected from friends',
        createdAt: now.subtract(const Duration(days: 2)),
        isReleased: true,
        reflection: releasedReflections[1],
        emotion: 'sad',
        size: 92,
        posX: 80,
        posY: 220,
      ),
      // Unreleased across last 3 days
      Bubble(
        id: 'demo_3',
        worry: 'Too much on my mind lately',
        createdAt: now.subtract(const Duration(days: 2)),
        isReleased: false,
        emotion: 'anxious',
        size: 110,
        posX: 160,
        posY: 100,
      ),
      Bubble(
        id: 'demo_4',
        worry: 'Sleep has been rough',
        createdAt: now.subtract(const Duration(days: 1)),
        isReleased: false,
        emotion: 'tired',
        size: 88,
        posX: 90,
        posY: 260,
      ),
      Bubble(
        id: 'demo_5',
        worry: 'Small things keep annoying me',
        createdAt: now.subtract(const Duration(days: 1)),
        isReleased: false,
        emotion: 'angry',
        size: 96,
        posX: 200,
        posY: 140,
      ),
      Bubble(
        id: 'demo_6',
        worry: 'Worried about tomorrow\'s presentation',
        createdAt: now,
        isReleased: false,
        emotion: 'anxious',
        size: 104,
        posX: 130,
        posY: 200,
      ),
      Bubble(
        id: 'demo_7',
        worry: 'Need to find time to rest',
        createdAt: now,
        isReleased: false,
        emotion: 'tired',
        size: 85,
        posX: 170,
        posY: 160,
      ),
    ];
    _bubbles.clear();
    _bubbles.addAll(demoBubbles);
    _dailyBubbleCount = demoBubbles.where((b) => _isToday(b.createdAt)).length;
    notifyListeners();
    _persistBubbles();
    return demoBubbles.where((b) => b.isReleased).toList();
  }
}
