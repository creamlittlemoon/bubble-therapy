import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bubble_provider.dart';
import '../providers/memory_provider.dart';
import '../theme/app_colors.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bubbleProvider = Provider.of<BubbleProvider>(context);
    final memoryProvider = Provider.of<MemoryProvider>(context);
    final emotions = memoryProvider.getEmotionInsights();
    final weeklyStats = memoryProvider.getWeeklyStats();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Insights',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Understanding your emotional patterns',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Bubbles',
                      bubbleProvider.totalBubbles.toString(),
                      Icons.bubble_chart,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Released',
                      bubbleProvider.releasedCount.toString(),
                      Icons.check_circle,
                      AppColors.accentGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Stars',
                      memoryProvider.starCount.toString(),
                      Icons.star,
                      AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Pending',
                      bubbleProvider.pendingCount.toString(),
                      Icons.hourglass_empty,
                      AppColors.emotionAnxious,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Weekly Summary
              if (bubbleProvider.totalBubbles > 0) ...[
                Text(
                  'This Week',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weeklyStats.summary,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildWeekStat(
                            'Bubbles',
                            weeklyStats.totalBubbles.toString(),
                          ),
                          const SizedBox(width: 24),
                          _buildWeekStat(
                            'Released',
                            weeklyStats.releasedBubbles.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Emotion Distribution
              if (emotions.isNotEmpty) ...[
                Text(
                  'Emotion Distribution',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                ...emotions.map((emotion) => _buildEmotionBar(emotion)),
              ],

              // Empty State
              if (bubbleProvider.totalBubbles == 0)
                _buildEmptyState(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionBar(dynamic emotion) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                emotion.emotion,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${emotion.percentage.toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: emotion.percentage / 100,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getEmotionColor(emotion.emotion),
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    final colors = {
      'anxious': AppColors.emotionAnxious,
      'sad': AppColors.emotionSad,
      'angry': AppColors.emotionAngry,
      'stressed': AppColors.emotionStressed,
      'tired': AppColors.emotionTired,
      'lonely': AppColors.emotionLonely,
    };
    return colors[emotion.toLowerCase()] ?? AppColors.primary;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.insights_outlined,
            size: 80,
            color: AppColors.disabled,
          ),
          const SizedBox(height: 16),
          Text(
            'No insights yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create and release bubbles to see your patterns',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
