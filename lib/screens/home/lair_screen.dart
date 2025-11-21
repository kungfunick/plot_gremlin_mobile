import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/gremlin_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/atmospheric_background.dart';
import '../../widgets/blood_bar.dart';
import '../../widgets/settings_panel.dart';
import '../../widgets/output_panel.dart';
import '../../services/audio_service.dart';

class LairScreen extends StatefulWidget {
  const LairScreen({super.key});

  @override
  State<LairScreen> createState() => _LairScreenState();
}

class _LairScreenState extends State<LairScreen> {
  final AudioService _audioService = AudioService();
  bool _isRecording = false;
  Timer? _idleTimer;
  DateTime _lastActivityTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startIdleTimer();
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _audioService.dispose();
    super.dispose();
  }

  void _startIdleTimer() {
    _idleTimer?.cancel();

    final settings = context.read<SettingsProvider>();
    if (!settings.idleChatter) return;

    _idleTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final diff = now.difference(_lastActivityTime).inSeconds;

      if (diff >= settings.idleInterval) {
        _showIdleChatter();
        _lastActivityTime = now;
      }
    });
  }

  void _resetActivity() {
    setState(() {
      _lastActivityTime = DateTime.now();
    });
  }

  void _showIdleChatter() {
    final gremlin = context.read<GremlinProvider>();
    final messages = gremlin.getIdleChatterMessages();
    final message = messages[DateTime.now().millisecond % messages.length];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.bloodRed.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _toggleRecording() async {
    _resetActivity();

    final settings = context.read<SettingsProvider>();
    final gremlin = context.read<GremlinProvider>();

    if (!settings.liveListen) {
      // Generate without recording
      _generateSuggestion();
      return;
    }

    if (_isRecording) {
      // Stop recording
      setState(() => _isRecording = false);

      final transcript = await _audioService.stopRecording();

      if (transcript != null) {
        gremlin.addTranscript(transcript);

        if (gremlin.transcriptCount >= settings.aggregate) {
          _generateSuggestion();
        }
      }
    } else {
      // Start recording
      final hasPermission = await _audioService.requestPermission();

      if (!hasPermission) {
        _showError('Microphone permission denied');
        return;
      }

      await _audioService.startRecording();
      setState(() => _isRecording = true);
    }
  }

  Future<void> _generateSuggestion() async {
    final settings = context.read<SettingsProvider>();
    final gremlin = context.read<GremlinProvider>();

    final suggestion = await gremlin.generateSuggestion(
      provider: settings.provider,
      apiKey: settings.apiKey,
    );

    // Suggestion is now available in gremlin.lastSuggestion
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.bloodRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetActivity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PLOT GREMLIN'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await context.read<AuthProvider>().signOut();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            const AtmosphericBackground(),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header
                    Text(
                      '🗡',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 64,
                        shadows: [
                          Shadow(
                            color: AppTheme.bloodRed.withOpacity(0.9),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Keeper of Dark Secrets',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontStyle: FontStyle.italic,
                        letterSpacing: 3,
                        color: AppTheme.textDim,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Settings Panel
                    SettingsPanel(onSave: _startIdleTimer),
                    const SizedBox(height: 32),

                    // Blood Bar Progress
                    Consumer2<GremlinProvider, SettingsProvider>(
                      builder: (context, gremlin, settings, _) {
                        return BloodBar(
                          current: gremlin.transcriptCount,
                          total: settings.aggregate,
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Summon Button
                    Consumer<GremlinProvider>(
                      builder: (context, gremlin, _) {
                        return ElevatedButton(
                          onPressed: gremlin.isGenerating ? null : _toggleRecording,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 20,
                            ),
                            backgroundColor: _isRecording
                                ? AppTheme.bloodLight.withOpacity(0.9)
                                : null,
                          ),
                          child: gremlin.isGenerating
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppTheme.textLight,
                                  ),
                                )
                              : Text(
                                  _isRecording ? 'LISTENING...' : 'SUMMON',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 5,
                                  ),
                                ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Output Panel
                    const OutputPanel(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}