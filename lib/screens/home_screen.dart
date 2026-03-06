import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/bubble_provider.dart';
import '../providers/memory_provider.dart';
import '../widgets/home_ambient_layer.dart';
import 'write_bubble_screen.dart';
import 'reflection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bubbleProvider = Provider.of<BubbleProvider>(context);
    final unreleased = bubbleProvider.unreleasedBubbles;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            // Foreground UI layer: header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bubble Therapy',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Release your worries into bubbles',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                  Opacity(
                    opacity: 0.45,
                    child: Icon(
                      Icons.bubble_chart,
                      size: 28,
                      color: const Color(0xFF6B9AC4),
                    ),
                  ),
                ],
              ),
            ),

            // Middle: ambient layer + interactive bubble layer (or empty state)
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Layer 1 — background ambient (decorative only)
                  Positioned.fill(
                    child: const HomeAmbientLayer(),
                  ),
                  // Layer 2 — interactive user bubbles or empty-state overlay
                  Positioned.fill(
                    child: unreleased.isEmpty
                        ? _buildEmptyState(context)
                        : _buildBubbleFloatArea(context, unreleased),
                  ),
                ],
              ),
            ),

            // Foreground UI layer: CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WriteBubbleScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B9AC4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline),
                      SizedBox(width: 8),
                      Text(
                        'New Bubble',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your mind is clear for now',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                .slideY(begin: 0.08, end: 0, duration: 500.ms, curve: Curves.easeOut),
            const SizedBox(height: 12),
            const Text(
              'When something feels heavy, tap "New Bubble" below. '
              'Write it down, turn it into a bubble, and release it when you\'re ready.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF718096),
                height: 1.55,
              ),
            )
                .animate(delay: 150.ms)
                .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                .slideY(begin: 0.06, end: 0, duration: 450.ms, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }

  Widget _buildBubbleFloatArea(BuildContext context, List bubbles) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const SizedBox.expand(), // Fill layer so Stack takes full area
        ...bubbles.asMap().entries.map((entry) {
        final index = entry.key;
        final bubble = entry.value;
        
        return Positioned(
          left: bubble.posX ?? (50 + index * 30.0),
          top: bubble.posY ?? (100 + index * 40.0),
          child: GestureDetector(
            onTap: () {
              _showBubbleOptions(context, bubble);
            },
            child: _buildBubbleWidget(bubble),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .move(begin: const Offset(0, -4), end: const Offset(0, 4), duration: (2400 + index * 180).ms),
        );
      }),
      ],
    );
  }

  Widget _buildBubbleWidget(dynamic bubble) {
    final size = bubble.size ?? 100.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF6B9AC4).withOpacity(0.45),
            const Color(0xFF6B9AC4).withOpacity(0.18),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF6B9AC4).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B9AC4).withOpacity(0.25),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            bubble.worry.length > 20 
                ? '${bubble.worry.substring(0, 20)}...' 
                : bubble.worry,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size > 100 ? 14 : 12,
              color: const Color(0xFF4A5568),
            ),
          ),
        ),
      ),
    );
  }

  void _showBubbleOptions(BuildContext context, dynamic bubble) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '"${bubble.worry}"',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Color(0xFF4A5568),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildOptionButton(
              context,
              'Release Bubble',
              Icons.favorite_border,
              const Color(0xFF6B9AC4),
              () {
                Navigator.pop(context);
                _showReleaseDialog(context, bubble);
              },
            ),
            const SizedBox(height: 12),
            _buildOptionButton(
              context,
              'Pop Bubble',
              Icons.close,
              const Color(0xFFE8A87C),
              () {
                Navigator.pop(context);
                Provider.of<BubbleProvider>(context, listen: false)
                    .popBubble(bubble.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReleaseDialog(BuildContext context, dynamic bubble) {
    final emotions = ['Anxious', 'Sad', 'Angry', 'Stressed', 'Tired', 'Lonely'];
    String? selectedEmotion;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('How are you feeling?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select an emotion (optional)'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: emotions.map((emotion) => GestureDetector(
                  onTap: () => setState(() => selectedEmotion = emotion),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selectedEmotion == emotion
                          ? const Color(0xFF6B9AC4)
                          : const Color(0xFFEDF2F7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      emotion,
                      style: TextStyle(
                        color: selectedEmotion == emotion
                            ? Colors.white
                            : const Color(0xFF4A5568),
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                final provider = Provider.of<BubbleProvider>(context, listen: false);
                provider.releaseBubble(
                  bubble.id,
                  emotion: selectedEmotion,
                );
                
                // Add to memory
                final updatedBubble = provider.bubbles.firstWhere(
                  (b) => b.id == bubble.id,
                );
                Provider.of<MemoryProvider>(context, listen: false)
                    .addStar(updatedBubble);
                
                // Show reflection
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReflectionScreen(
                      worry: bubble.worry,
                      reflection: updatedBubble.reflection ?? '',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B9AC4),
              ),
              child: const Text('Release'),
            ),
          ],
        ),
      ),
    );
  }
}
