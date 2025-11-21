import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/settings_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class BloodBar extends StatefulWidget {
  final int current;
  final int total;

  const BloodBar({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  State<BloodBar> createState() => _BloodBarState();
}

class _BloodBarState extends State<BloodBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasPlayedSound = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void didUpdateWidget(BloodBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Play sound when bar fills up
    if (widget.current >= widget.total &&
        oldWidget.current < oldWidget.total &&
        !_hasPlayedSound) {
      _playSound();
      _hasPlayedSound = true;
    }

    // Reset sound flag when bar empties
    if (widget.current < widget.total) {
      _hasPlayedSound = false;
    }
  }

  Future<void> _playSound() async {
    final settings = context.read<SettingsProvider>();
    if (settings.enableSound) {
      try {
        await _audioPlayer.play(AssetSource('audio/blood_fill.mp3'));
      } catch (e) {
        debugPrint('Error playing sound: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.total > 0
        ? (widget.current / widget.total).clamp(0.0, 1.0)
        : 0.0;
    final isFull = progress >= 1.0;

    return Column(
      children: [
        // Progress Label
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RITUAL PROGRESS',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                '${widget.current}/${widget.total}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Blood Bar Container
        Container(
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: const Color(0xFF140000).withOpacity(0.8),
            border: Border.all(
              color: const Color(0xFF3C0000).withOpacity(0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.9),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: -2,
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  // Animated blood fill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    width: MediaQuery.of(context).size.width * progress,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppTheme.bloodRed,
                          AppTheme.bloodLight,
                          AppTheme.bloodRed,
                        ],
                        stops: [
                          _controller.value,
                          (_controller.value + 0.5) % 1.0,
                          (_controller.value + 1.0) % 1.0,
                        ],
                      ),
                      boxShadow: isFull
                          ? [
                              BoxShadow(
                                color: AppTheme.bloodLight.withOpacity(0.8),
                                blurRadius: 10,
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: AppTheme.bloodRed.withOpacity(0.8),
                                blurRadius: 10,
                              ),
                            ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}