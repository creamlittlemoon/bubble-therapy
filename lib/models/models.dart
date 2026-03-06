// Bubble Model
class Bubble {
  final String id;
  final String worry;
  final DateTime createdAt;
  final bool isReleased;
  final String? reflection;
  final String? emotion;
  final double? size;
  final double? posX;
  final double? posY;

  Bubble({
    required this.id,
    required this.worry,
    required this.createdAt,
    this.isReleased = false,
    this.reflection,
    this.emotion,
    this.size,
    this.posX,
    this.posY,
  });

  Bubble copyWith({
    bool? isReleased,
    String? reflection,
    String? emotion,
  }) {
    return Bubble(
      id: id,
      worry: worry,
      createdAt: createdAt,
      isReleased: isReleased ?? this.isReleased,
      reflection: reflection ?? this.reflection,
      emotion: emotion ?? this.emotion,
      size: size,
      posX: posX,
      posY: posY,
    );
  }
}

// Star Model (released bubbles become stars)
class Star {
  final String id;
  final String originalBubbleId;
  final String worry;
  final String reflection;
  final DateTime releasedAt;
  final String? emotion;
  final double brightness;

  Star({
    required this.id,
    required this.originalBubbleId,
    required this.worry,
    required this.reflection,
    required this.releasedAt,
    this.emotion,
    this.brightness = 1.0,
  });
}

// Emotion Insight Model
class EmotionInsight {
  final String emotion;
  final int count;
  final double percentage;

  EmotionInsight({
    required this.emotion,
    required this.count,
    required this.percentage,
  });
}

// Weekly Stats Model
class WeeklyStats {
  final DateTime weekStart;
  final int totalBubbles;
  final int releasedBubbles;
  final List<EmotionInsight> topEmotions;
  final String summary;

  WeeklyStats({
    required this.weekStart,
    required this.totalBubbles,
    required this.releasedBubbles,
    required this.topEmotions,
    required this.summary,
  });
}
