import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bubble_provider.dart';

class BubblePoolScreen extends StatelessWidget {
  const BubblePoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bubbleProvider = Provider.of<BubbleProvider>(context);
    final todaysBubbles = bubbleProvider.todaysBubbles;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today\'s Bubbles',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${todaysBubbles.length} bubbles created',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                  if (todaysBubbles.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8A87C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            todaysBubbles.length > 5 
                                ? Icons.warning_amber 
                                : Icons.check_circle,
                            size: 16,
                            color: const Color(0xFFE8A87C),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            todaysBubbles.length > 5 
                                ? 'Take a breath' 
                                : 'Doing well',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFE8A87C),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Bubble List
            Expanded(
              child: todaysBubbles.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: todaysBubbles.length,
                      itemBuilder: (context, index) {
                        final bubble = todaysBubbles[index];
                        return _buildBubbleCard(bubble);
                      },
                    ),
            ),

            // Night Ritual Button
            if (todaysBubbles.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _showNightRitualDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D3748),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.nightlight_round),
                        SizedBox(width: 8),
                        Text(
                          'Night Ritual',
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bubble_chart_outlined,
            size: 80,
            color: const Color(0xFFCBD5E0),
          ),
          const SizedBox(height: 16),
          const Text(
            'No bubbles yet today',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a bubble when you need to release something',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubbleCard(dynamic bubble) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bubble.isReleased 
            ? const Color(0xFF6B9AC4).withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: bubble.isReleased
              ? const Color(0xFF6B9AC4).withOpacity(0.3)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: bubble.isReleased
                      ? const Color(0xFF6B9AC4).withOpacity(0.2)
                      : const Color(0xFFEDF2F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  bubble.isReleased ? 'Released' : 'Pending',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: bubble.isReleased
                        ? const Color(0xFF6B9AC4)
                        : const Color(0xFF718096),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${bubble.createdAt.hour}:${bubble.createdAt.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFA0AEC0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            bubble.worry,
            style: TextStyle(
              fontSize: 15,
              color: const Color(0xFF2D3748),
              decoration: bubble.isReleased
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          if (bubble.emotion != null) ...[
            const SizedBox(height: 8),
            Text(
              'Feeling: ${bubble.emotion}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF718096),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showNightRitualDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Night Ritual'),
        content: const Text(
          'Release all remaining bubbles from today?\n\n'
          'This will transform your worries into stars in your Memory Sky.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<BubbleProvider>(context, listen: false)
                  .drainAllBubbles();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All bubbles released. Sleep well. 🌙'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D3748),
            ),
            child: const Text('Release All'),
          ),
        ],
      ),
    );
  }
}
