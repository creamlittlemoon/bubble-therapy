import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bubble_provider.dart';
import '../providers/memory_provider.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bubbleProvider = Provider.of<BubbleProvider>(context);
    final memoryProvider = Provider.of<MemoryProvider>(context);
    final emotions = memoryProvider.getEmotionInsights();
    final weeklyStats = memoryProvider.getWeeklyStats();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Insights',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Understanding your emotional patterns',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF718096),
                ),
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
                      const Color(0xFF6B9AC4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Released',
                      bubbleProvider.releasedCount.toString(),
                      Icons.check_circle,
                      const Color(0xFF7C9885),
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
                      const Color(0xFFE8A87C),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Pending',
                      bubbleProvider.pendingCount.toString(),
                      Icons.hourglass_empty,
                      const Color(0xFF9F7AEA),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Weekly Summary
              if (bubbleProvider.totalBubbles > 0) ...[
                const Text(
                  'This Week',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
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
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4A5568),
                          height: 1.6,
                        ),
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
                const Text(
                  'Emotion Distribution',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
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
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
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
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF718096),
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4A5568),
                ),
              ),
              Text(
                '${emotion.percentage.toInt()}%',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: emotion.percentage / 100,
              backgroundColor: const Color(0xFFEDF2F7),
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
      'anxious': const Color(0xFF9F7AEA),
      'sad': const Color(0xFF63B3ED),
      'angry': const Color(0xFFFC8181),
      'stressed': const Color(0xFFE8A87C),
      'tired': const Color(0xFF718096),
      'lonely': const Color(0xFF4A5568),
    };
    return colors[emotion.toLowerCase()] ?? const Color(0xFF6B9AC4);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.insights_outlined,
            size: 80,
            color: const Color(0xFFCBD5E0),
          ),
          const SizedBox(height: 16),
          const Text(
            'No insights yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create and release bubbles to see your patterns',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }
}
