import 'package:flutter/material.dart';
import 'dart:math' as math;

class AtmosphericBackground extends StatefulWidget {
  const AtmosphericBackground({super.key});

  @override
  State<AtmosphericBackground> createState() => _AtmosphericBackgroundState();
}

class _AtmosphericBackgroundState extends State<AtmosphericBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 45),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.5,
              colors: [
                const Color(0xFF0A0A0A),
                const Color(0xFF0A0A0A).withOpacity(0.95),
              ],
            ),
          ),
        ),

        // Animated flicker effect
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: 0.6 + (math.sin(_controller.value * 2 * math.pi) * 0.2),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      math.sin(_controller.value * 2 * math.pi) * 0.3,
                      math.cos(_controller.value * 2 * math.pi) * 0.3,
                    ),
                    radius: 0.8,
                    colors: [
                      const Color(0xFF8B0000).withOpacity(0.03),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}