import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioService {
  final AudioRecorder _recorder = AudioRecorder();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  String? _currentRecordingPath;

  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> startRecording() async {
    try {
      if (!_isInitialized) {
        _isInitialized = await _speech.initialize();
      }

      // Check permission
      if (!await _recorder.hasPermission()) {
        throw Exception('Microphone permission not granted');
      }

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '${tempDir.path}/recording_$timestamp.m4a';

      // Start recording
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          sampleRate: 44100,
          bitRate: 128000,
        ),
        path: _currentRecordingPath!,
      );
    } catch (e) {
      throw Exception('Failed to start recording: $e');
    }
  }

  Future<String?> stopRecording() async {
    try {
      // Stop recording
      final path = await _recorder.stop();

      if (path == null) {
        return null;
      }

      // For now, return a placeholder transcription
      // In production, you would:
      // 1. Use speech_to_text for offline recognition
      // 2. Or send audio to your backend for transcription
      // 3. Or use a cloud speech API

      return await _transcribeAudio(path);
    } catch (e) {
      throw Exception('Failed to stop recording: $e');
    }
  }

  Future<String> _transcribeAudio(String path) async {
    try {
      // Placeholder for transcription
      // In a real app, you would:
      // 1. Use speech_to_text library for offline transcription
      // 2. Send to backend API for transcription
      // 3. Use Google Cloud Speech-to-Text or similar

      // For demo purposes, return a placeholder
      final file = File(path);
      final exists = await file.exists();

      if (!exists) {
        return '🧌 Audio file not found';
      }

      // Check file size to give context-aware response
      final size = await file.length();

      if (size < 10000) {
        return '📝 [Recording too short - please speak longer]';
      }

      // In production, implement actual transcription here
      return '📝 [Audio recorded - offline transcription not yet implemented. Connect to API for real transcription]';

      // Example with speech_to_text (requires setup):
      /*
      if (_speech.isAvailable) {
        bool available = await _speech.listen(
          onResult: (result) {
            return result.recognizedWords;
          },
        );
        if (available) {
          // Return transcribed text
        }
      }
      */

    } catch (e) {
      return '🧌 Transcription error: $e';
    } finally {
      // Clean up recording file
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore cleanup errors
      }
    }
  }

  void dispose() {
    _recorder.dispose();
    _speech.stop();
  }
}