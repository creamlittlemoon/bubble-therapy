import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Non-interactive ambient layer for the home screen: decorative bubbles,
/// soft mist, and drifting particles. Kept visually distinct from user bubbles
/// via low opacity and no text. Renders behind the interactive bubble layer.
class HomeAmbientLayer extends StatelessWidget {
  const HomeAmbientLayer({super.key});

  static const _accent = Color(0xFF6B9AC4);
  static const _mistOpacity = 0.04;
  static const _bubbleOpacity = 0.18;
  static const _particleOpacity = 0.10;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _buildMist(w, h),
            ..._buildDecorativeBubbles(w, h),
            ..._buildParticles(w, h),
          ],
        );
      },
    );
  }

  Widget _buildMist(double w, double h) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Soft radial mist — top-left
            Positioned(
              left: -w * 0.2,
              top: -h * 0.1,
              child: Container(
                width: w * 0.9,
                height: h * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _accent.withOpacity(_mistOpacity),
                      _accent.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            // Soft radial mist — bottom-right
            Positioned(
              right: -w * 0.15,
              bottom: -h * 0.15,
              child: Container(
                width: w * 0.8,
                height: h * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _accent.withOpacity(_mistOpacity * 0.8),
                      _accent.withOpacity(0),
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

  List<Widget> _buildDecorativeBubbles(double w, double h) {
    // Fixed layout: (left ratio, top ratio, size) — distributed so center isn't overloaded
    const bubbles = [
      (0.08, 0.12, 52.0),
      (0.78, 0.18, 38.0),
      (0.15, 0.55, 44.0),
      (0.72, 0.48, 58.0),
      (0.85, 0.72, 36.0),
      (0.22, 0.78, 48.0),
      (0.50, 0.28, 42.0),
      (0.38, 0.65, 34.0),
      (0.62, 0.82, 40.0),
      (0.92, 0.42, 30.0),
      (0.05, 0.42, 46.0),
      (0.55, 0.58, 36.0),
    ];
    return bubbles.asMap().entries.map((entry) {
      final i = entry.key;
      final (lr, tr, size) = entry.value;
      final left = w * lr - size / 2;
      final top = h * tr - size / 2;
      return Positioned(
        left: left,
        top: top,
        child: _DecorativeBubble(size: size, index: i),
      );
    }).toList();
  }

  List<Widget> _buildParticles(double w, double h) {
    const particles = [
      (0.12, 0.25, 5.0),
      (0.88, 0.35, 4.0),
      (0.25, 0.88, 6.0),
      (0.75, 0.12, 4.0),
      (0.45, 0.72, 5.0),
      (0.60, 0.45, 4.0),
      (0.32, 0.38, 5.0),
      (0.95, 0.68, 4.0),
    ];
    return particles.asMap().entries.map((entry) {
      final i = entry.key;
      final (lr, tr, size) = entry.value;
      final left = w * lr - size / 2;
      final top = h * tr - size / 2;
      return Positioned(
        left: left,
        top: top,
        child: _Particle(size: size, index: i),
      );
    }).toList();
  }
}

class _DecorativeBubble extends StatelessWidget {
  const _DecorativeBubble({required this.size, required this.index});

  final double size;
  final int index;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              HomeAmbientLayer._accent.withOpacity(HomeAmbientLayer._bubbleOpacity),
              HomeAmbientLayer._accent.withOpacity(HomeAmbientLayer._bubbleOpacity * 0.3),
            ],
          ),
          border: Border.all(
            color: HomeAmbientLayer._accent.withOpacity(0.12),
            width: 1,
          ),
        ),
      )
          .animate(delay: (index * 80).ms)
          .fadeIn(duration: 800.ms, curve: Curves.easeOut)
          .then()
          .moveY(
            begin: 2,
            end: -2,
            duration: (2800 + index * 200).ms,
            curve: Curves.easeInOut,
          )
          .animate(onPlay: (c) => c.repeat(reverse: true)),
    );
  }
}

class _Particle extends StatelessWidget {
  const _Particle({required this.size, required this.index});

  final double size;
  final int index;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: HomeAmbientLayer._accent.withOpacity(HomeAmbientLayer._particleOpacity),
        ),
      )
          .animate(delay: (index * 120).ms)
          .fadeIn(duration: 600.ms)
          .then()
          .move(
            begin: Offset(1.5, 0.5),
            end: Offset(-1.5, -0.5),
            duration: (4000 + index * 300).ms,
            curve: Curves.easeInOut,
          )
          .animate(onPlay: (c) => c.repeat(reverse: true)),
    );
  }
}
