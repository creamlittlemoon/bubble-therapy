# Bubble Therapy

一款面向海外市场的 Wellness App，帮助用户通过呼吸练习、冥想和情绪追踪来管理压力和焦虑。

## 项目概述

**目标市场**: 北美/欧洲海外市场  
**核心价值**: 通过科学的呼吸练习和正念冥想，帮助用户缓解压力、改善睡眠、提升专注力  
**MVP功能**:
1. 呼吸练习引导（多种呼吸模式）
2. 冥想音频播放
3. 情绪日记记录
4. 进度统计

## 技术栈

- **框架**: Flutter (跨平台 iOS/Android)
- **音频**: audioplayers
- **状态管理**: Provider
- **本地存储**: shared_preferences + hive
- **国际化**: flutter_localizations

## 项目结构

```
lib/
├── main.dart
├── app.dart
├── models/
│   ├── breathing_pattern.dart
│   ├── meditation_session.dart
│   └── mood_entry.dart
├── screens/
│   ├── home_screen.dart
│   ├── breathing_screen.dart
│   ├── meditation_screen.dart
│   ├── mood_screen.dart
│   └── stats_screen.dart
├── widgets/
│   ├── breathing_circle.dart
│   ├── meditation_card.dart
│   └── mood_selector.dart
├── providers/
│   ├── breathing_provider.dart
│   └── mood_provider.dart
└── utils/
    ├── audio_player.dart
    └── localization.dart
```

## 开发计划

1. ✅ 项目初始化
2. 🔄 MVP核心功能开发中
3. ⏳ UI/UX 优化
4. ⏳ 国际化支持
5. ⏳ 测试与发布

## 设计规范

- **主色调**: 柔和蓝紫色系 (#7C9D96, #9CAF88, #E5E5E5)
- **字体**: Inter / SF Pro
- **风格**: 极简、治愈、有机曲线
