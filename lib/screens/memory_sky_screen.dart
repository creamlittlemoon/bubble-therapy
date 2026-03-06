import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/memory_provider.dart';

class MemorySkyScreen extends StatelessWidget {
  const MemorySkyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final memoryProvider = Provider.of<MemoryProvider>(context);
    final stars = memoryProvider.stars;

    return Scaffold(
      backgroundColor: const Color(0xFF1A202C),
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
                        'Memory Sky',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${stars.length} stars shining',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFA0AEC0),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8A87C).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Color(0xFFE8A87C),
                    ),
                  ),
                ],
              ),
            ),

            // Star Sky
            Expanded(
              child: stars.isEmpty
                  ? _buildEmptyState()
                  : _buildStarGrid(stars),
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
            Icons.nightlight_round,
            size: 80,
            color: const Color(0xFF4A5568),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your sky is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Release bubbles to create stars',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFA0AEC0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarGrid(List stars) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: stars.length,
      itemBuilder: (context, index) {
        final star = stars[index];
        return _buildStarItem(context, star, index);
      },
    );
  }

  Widget _buildStarItem(BuildContext context, dynamic star, int index) {
    final brightness = (star.brightness as num).toDouble();
    return GestureDetector(
      onTap: () => _showStarDetail(context, star),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8A87C).withOpacity(brightness * 0.3),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8A87C).withOpacity(brightness * 0.5),
              blurRadius: 20 * brightness,
              spreadRadius: 5 * brightness,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.star,
            color: const Color(0xFFE8A87C).withOpacity(0.8 + brightness * 0.2),
            size: 24.0 + brightness * 16,
          ),
        ),
      ),
    )
        .animate(delay: (index * 100).ms)
        .fadeIn(duration: 500.ms)
        .scaleXY(begin: 0, end: 1, duration: 500.ms);
  }

  void _showStarDetail(BuildContext context, dynamic star) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF2D3748),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF4A5568),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(
              Icons.star,
              size: 48,
              color: Color(0xFFE8A87C),
            ),
            const SizedBox(height: 16),
            Text(
              'Released on ${_formatDate(star.releasedAt)}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFA0AEC0),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A202C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '"${star.worry}"',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFCBD5E0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6B9AC4).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                star.reflection,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF90CDF4),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
