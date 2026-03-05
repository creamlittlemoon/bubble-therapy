# Bubble Therapy - AI Blueprint Implementation

一款面向海外市场的 AI 驱动 Wellness App。

## 核心概念

**产品定位**: AI-Powered Stress Relief Companion  
**目标用户**: 25-40岁都市压力人群  
**核心价值**: 通过 AI 个性化呼吸指导和情绪追踪，帮助用户科学减压

## AI 功能模块

### 1. 智能呼吸教练 (Smart Breathing Coach)
- 根据用户当前心率/压力水平推荐呼吸模式
- 实时语音引导
- 自适应节奏调整

### 2. 情绪 AI 分析 (Mood AI Analysis)
- 语音情绪识别
- 压力趋势预测
- 个性化建议生成

### 3. 个性化冥想推荐 (AI Meditation Curator)
- 基于历史数据推荐内容
- A/B 测试优化推荐效果
- 用户反馈学习

## 技术实现

### 本地 AI (On-Device)
- TensorFlow Lite 情绪识别模型
- 本地数据处理，保护隐私

### 云端 AI (Cloud)
- 语音转情绪分析 API
- 个性化推荐引擎
- 用户行为分析

## 数据结构

```json
{
  "userProfile": {
    "stressLevel": "medium",
    "preferredDuration": 10,
    "goals": ["sleep", "focus", "calm"],
    "aiModel": "personalized_v1"
  },
  "sessionData": {
    "breathingPattern": "4-7-8",
    "heartRate": [72, 68, 65, 62],
    "moodBefore": "anxious",
    "moodAfter": "relaxed",
    "aiRecommendation": "increase_duration"
  }
}
```

## 开发进度

- [x] 项目架构搭建
- [x] 基础 UI 框架
- [ ] AI 模型集成
- [ ] 语音引导系统
- [ ] 情绪分析引擎
- [ ] 个性化推荐

## 项目优先级

1. 猫猫拼字游戏 (最高)
2. Bubble Therapy (高) - AI 功能开发中
3. 墨山河书法地图 (中)
