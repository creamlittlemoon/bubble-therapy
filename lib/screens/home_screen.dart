import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_breathing_provider.dart';
import '../providers/mood_provider.dart';
import 'breathing_screen.dart';
import 'mood_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with AI greeting
                _buildHeader(),
                const SizedBox(height: 24),
                
                // AI Recommendation Card
                _buildAIRecommendation(context),
                const SizedBox(height: 24),
                
                // Quick Stats
                _buildStatsRow(),
                const SizedBox(height: 32),
                
                // Main Features
                _buildSectionTitle('Start Your Practice'),
                const SizedBox(height: 16),
                _buildFeatureCards(context),
                const SizedBox(height: 32),
                
                // Today's Mood Section
                _buildSectionTitle('How are you feeling?'),
                const SizedBox(height: 16),
                _buildMoodSelector(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF7C9D96).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Color(0xFF7C9D96),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF7C9D96).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.smart_toy, size: 16, color: Color(0xFF7C9D96)),
                  SizedBox(width: 6),
                  Text(
                    'AI Powered',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7C9D96),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Bubble Therapy',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your personal AI wellness companion',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAIRecommendation(BuildContext context) {
    return Consumer<AIBreathingProvider>(
      builder: (context, provider, _) {
        if (provider.aiRecommendation == null) {
          return const SizedBox.shrink();
        }
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7C9D96), Color(0xFF9CAF88)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C9D96).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.psychology, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'AI Recommendation',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(provider.stressLevel * 100).toInt()}% stress',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                provider.aiRecommendation!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BreathingScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF7C9D96),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Start Recommended Session',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return Consumer2<AIBreathingProvider, MoodProvider>(
      builder: (context, breathingProvider, moodProvider, _) {
        return Row(
          children: [
            _buildStatCard(
              icon: Icons.local_fire_department,
              label: 'Day Streak',
              value: breathingProvider.currentStreak.toString(),
              color: const Color(0xFFFF7675),
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              icon: Icons.access_time,
              label: 'Minutes',
              value: breathingProvider.totalMinutes.toString(),
              color: const Color(0xFF74B9FF),
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              icon: Icons.emoji_emotions,
              label: 'Moods',
              value: moodProvider.moodHistory.length.toString(),
              color: const Color(0xFF9CAF88),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
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
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D3436),
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context) {
    return Column(
      children: [
        _buildFeatureCard(
          context,
          title: 'AI Breathing Coach',
          subtitle: 'Personalized breathing exercises',
          icon: Icons.air,
          color: const Color(0xFF7C9D96),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BreathingScreen()),
          ),
          badge: 'AI Powered',
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          context,
          title: 'Mood Tracker',
          subtitle: 'Track and analyze your emotions',
          icon: Icons.sentiment_satisfied,
          color: const Color(0xFF9CAF88),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MoodScreen()),
          ),
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          context,
          title: 'Wellness Insights',
          subtitle: 'AI-powered personalized reports',
          icon: Icons.insights,
          color: const Color(0xFFDDA0DD),
          onTap: () {},
          badge: 'Coming Soon',
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSelector(BuildContext context) {
    return Consumer<MoodProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: MoodType.values.map((mood) {
                  final isSelected = provider.currentMood == mood;
                  return GestureDetector(
                    onTap: () => provider.setMood(mood),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? provider.getMoodColor(mood).withOpacity(0.2)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(color: provider.getMoodColor(mood), width: 2)
                                : null,
                          ),
                          child: Text(
                            provider.getMoodEmoji(mood),
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          provider.getMoodLabel(mood),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected ? provider.getMoodColor(mood) : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              if (provider.currentMood != null) ...[
                const SizedBox(height: 20),
                if (provider.aiSuggestions.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C9D96).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lightbulb, color: Color(0xFF7C9D96), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'AI Suggestions',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7C9D96),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...provider.aiSuggestions.map((suggestion) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Color(0xFF7C9D96), size: 14),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  suggestion,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    provider.saveMoodEntry();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mood saved! Keep tracking for AI insights.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C9D96),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Log Mood',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
