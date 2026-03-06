import 'package:flutter/material.dart';
import '../models/models.dart';

class MemoryProvider extends ChangeNotifier {
  final List<Star> _stars = [];

  List<Star> get stars => _stars;
  int get starCount => _stars.length;

  void addStar(Bubble bubble) {
    if (bubble.isReleased && bubble.reflection != null) {
      final star = Star(
        id: 'star_${bubble.id}',
        originalBubbleId: bubble.id,
        worry: bubble.worry,
        reflection: bubble.reflection!,
        releasedAt: DateTime.now(),
        emotion: bubble.emotion,
        brightness: 0.5 + (bubble.worry.length / 100).clamp(0.0, 0.5),
      );
      
      _stars.add(star);
      notifyListeners();
    }
  }

  List<EmotionInsight> getEmotionInsights() {
    final emotionCounts = <String, int>{};
    
    for (var star in _stars) {
      if (star.emotion != null) {
        emotionCounts[star.emotion!] = (emotionCounts[star.emotion!] ?? 0) + 1;
      }
    }
    
    final total = emotionCounts.values.fold(0, (a, b) => a + b);
    if (total == 0) return [];
    
    return emotionCounts.entries
      .map((e) => EmotionInsight(
        emotion: e.key,
        count: e.value,
        percentage: (e.value / total * 100).roundToDouble(),
      ))
      .toList()
      ..sort((a, b) => b.count.compareTo(a.count));
  }

  WeeklyStats getWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    final weekStars = _stars.where((s) => 
      s.releasedAt.isAfter(weekStart) || 
      s.releasedAt.isAtSameMomentAs(weekStart)
    ).toList();
    
    final emotions = getEmotionInsights();
    final topEmotions = emotions.take(3).toList();
    
    String summary;
    if (weekStars.isEmpty) {
      summary = 'This week was quiet. Ready to listen when you are.';
    } else if (weekStars.length < 5) {
      summary = 'A gentle week. You\'re finding balance.';
    } else if (weekStars.length < 10) {
      summary = 'You\'ve been processing a lot. Be kind to yourself.';
    } else {
      summary = 'A transformative week. Growth often feels heavy.';
    }
    
    return WeeklyStats(
      weekStart: weekStart,
      totalBubbles: weekStars.length,
      releasedBubbles: weekStars.length,
      topEmotions: topEmotions,
      summary: summary,
    );
  }
}
