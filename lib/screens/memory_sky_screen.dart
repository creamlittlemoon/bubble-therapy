import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/memory_provider.dart';
import '../theme/app_colors.dart';

class MemorySkyScreen extends StatelessWidget {
  const MemorySkyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final memoryProvider = Provider.of<MemoryProvider>(context);
    final stars = memoryProvider.stars;

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
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
                      Text(
                        'Memory Sky',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${stars.length} stars shining',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurfaceDark,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryWithOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star,
                      color: AppColors.secondary,
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
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Your sky is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Release bubbles to create stars',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceDark,
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
          color: AppColors.secondary.withOpacity(brightness * 0.3),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(brightness * 0.5),
              blurRadius: 20 * brightness,
              spreadRadius: 5 * brightness,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.star,
            color: AppColors.secondary.withOpacity(0.8 + brightness * 0.2),
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
        decoration: BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Icon(
              Icons.star,
              size: 48,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Released on ${_formatDate(star.releasedAt)}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.onSurfaceDark,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '"${star.worry}"',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: AppColors.disabled,
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
                color: AppColors.primaryWithOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                star.reflection,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryLight,
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
