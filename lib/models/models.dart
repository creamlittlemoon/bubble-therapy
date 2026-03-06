import 'package:intl/intl.dart';

// Bubble Model — persisted locally with id, text, emotion, intensity, createdAt, status, dayKey
class Bubble {
  static String dayKeyFrom(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  final String id;
  final String worry;
  final DateTime createdAt;
  final bool isReleased;
  final String? reflection;
  final String? emotion;
  final int intensity; // 1–5
  final String dayKey; // yyyy-MM-dd for grouping by day
  final double? size;
  final double? posX;
  final double? posY;

  String get text => worry;
  String get status => isReleased ? 'released' : 'pending';

  Bubble({
    required this.id,
    required this.worry,
    required this.createdAt,
    this.isReleased = false,
    this.reflection,
    this.emotion,
    this.intensity = 3,
    String? dayKey,
    this.size,
    this.posX,
    this.posY,
  }) : dayKey = dayKey ?? dayKeyFrom(createdAt);

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
      intensity: intensity,
      dayKey: dayKey,
      size: size,
      posX: posX,
      posY: posY,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'worry': worry,
      'text': worry,
      'createdAt': createdAt.toIso8601String(),
      'isReleased': isReleased,
      'reflection': reflection,
      'emotion': emotion,
      'intensity': intensity,
      'dayKey': dayKey,
      'status': status,
      'size': size,
      'posX': posX,
      'posY': posY,
    };
  }

  static Bubble fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['createdAt'] as String);
    return Bubble(
      id: json['id'] as String,
      worry: (json['worry'] ?? json['text']) as String,
      createdAt: createdAt,
      isReleased: json['isReleased'] as bool? ?? false,
      reflection: json['reflection'] as String?,
      emotion: json['emotion'] as String?,
      intensity: (json['intensity'] as int?) ?? 3,
      dayKey: json['dayKey'] as String? ?? dayKeyFrom(createdAt),
      size: (json['size'] as num?)?.toDouble(),
      posX: (json['posX'] as num?)?.toDouble(),
      posY: (json['posY'] as num?)?.toDouble(),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalBubbleId': originalBubbleId,
      'worry': worry,
      'reflection': reflection,
      'releasedAt': releasedAt.toIso8601String(),
      'emotion': emotion,
      'brightness': brightness,
    };
  }

  static Star fromJson(Map<String, dynamic> json) {
    return Star(
      id: json['id'] as String,
      originalBubbleId: json['originalBubbleId'] as String,
      worry: json['worry'] as String,
      reflection: json['reflection'] as String,
      releasedAt: DateTime.parse(json['releasedAt'] as String),
      emotion: json['emotion'] as String?,
      brightness: (json['brightness'] as num?)?.toDouble() ?? 1.0,
    );
  }
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

/// Per-day summary for the last 7 days view.
class DaySummary {
  final String dayKey;
  final DateTime date;
  final int totalBubbles;
  final int releasedCount;
  final int pendingCount;
  final bool isToday;

  DaySummary({
    required this.dayKey,
    required this.date,
    required this.totalBubbles,
    required this.releasedCount,
    required this.pendingCount,
    required this.isToday,
  });
}
