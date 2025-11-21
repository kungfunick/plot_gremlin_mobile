import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GremlinProvider with ChangeNotifier {
  final List<String> _transcripts = [];
  bool _isGenerating = false;
  String? _lastSuggestion;

  List<String> get transcripts => List.unmodifiable(_transcripts);
  bool get isGenerating => _isGenerating;
  String? get lastSuggestion => _lastSuggestion;
  int get transcriptCount => _transcripts.length;

  void addTranscript(String transcript) {
    _transcripts.add(transcript);
    notifyListeners();
  }

  void clearTranscripts() {
    _transcripts.clear();
    notifyListeners();
  }

  Future<String> generateSuggestion({
    required String provider,
    String? apiKey,
  }) async {
    _isGenerating = true;
    notifyListeners();

    try {
      String suggestion;

      switch (provider) {
        case 'offline':
          suggestion = await _generateOfflineSuggestion();
          break;
        case 'openai':
          suggestion = await _generateOpenAISuggestion(apiKey ?? '');
          break;
        case 'free':
          suggestion = await _generateFreeSuggestion(apiKey ?? '');
          break;
        default:
          suggestion = await _generateOfflineSuggestion();
      }

      _lastSuggestion = suggestion;
      _transcripts.clear();

      return suggestion;
    } catch (e) {
      return '🧌 Plot Gremlin encountered an error: ${e.toString()}';
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  Future<String> _generateOfflineSuggestion() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final suggestions = [
      "🧌 Gremlin says: A wild plot twist emerges from the shadows!",
      "🧌 Gremlin whispers: Your party will stumble into trouble soon!",
      "🧌 Gremlin laughs: Someone's about to lose all their gold!",
      "🧌 Gremlin snickers: That mysterious NPC isn't what they seem...",
      "🧌 Gremlin cackles: Roll for chaos, adventurer!",
      "🧌 Gremlin grins: The treasure chest is actually a mimic. Surprise!",
      "🧌 Gremlin mutters: That innkeeper? Former assassin. Just saying.",
      "🧌 Gremlin giggles: The BBEG is having second thoughts about villainy.",
    ];

    String base = suggestions[Random().nextInt(suggestions.length)];

    if (_transcripts.isEmpty) return base;

    final context = _transcripts.join(' ').toLowerCase();
    String extra = '';

    if (context.contains('treasure') || context.contains('gold')) {
      extra = '\n\n💰 Also... that treasure might be cursed. Or already stolen. Or both!';
    } else if (context.contains('fight') || context.contains('battle')) {
      extra = '\n\n⚔️ Plot twist: The enemy wants to talk. They\'re just really bad at communication.';
    } else if (context.contains('tavern') || context.contains('inn')) {
      extra = '\n\n🍺 Fun fact: The bard in the corner is writing a song about YOUR mistakes.';
    } else if (context.contains('dragon')) {
      extra = '\n\n🐉 That dragon? Actually just wants someone to listen to their poetry.';
    }

    return '$base$extra';
  }

  Future<String> _generateOpenAISuggestion(String apiKey) async {
    if (apiKey.isEmpty) {
      return '🧌 Gremlin says: OpenAI API key not configured!';
    }

    try {
      final context = _transcripts.join('\n');
      final prompt = '''You are a sarcastic, mischievous Plot Gremlin that gives funny Dungeons & Dragons suggestions to a Dungeon Master.

Based on the following party audio transcript, give a brief, chaotic, and humorous suggestion for the next part of the adventure. Be creative, unexpected, and add a twist!

Keep your response under 100 words and make it entertaining.

Transcript: $context

Response as Plot Gremlin:''';

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': 'You are Plot Gremlin, a mischievous D&D story assistant who speaks with sass and creativity.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'max_tokens': 150,
          'temperature': 0.9,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final suggestion = data['choices'][0]['message']['content'];
        return '🧌 $suggestion';
      } else {
        return '🧌 Gremlin failed to summon OpenAI wisdom: ${response.statusCode}';
      }
    } catch (e) {
      return '🧌 Gremlin error: ${e.toString()}';
    }
  }

  Future<String> _generateFreeSuggestion(String apiKey) async {
    if (apiKey.isEmpty) {
      return '🧌 [Free API] Gremlin says: Configure your API key for premium mischief!';
    }

    final context = _transcripts.join('\n');
    return '🧌 [Free API] Gremlin noticed: \'${context.substring(0, context.length > 50 ? 50 : context.length)}...\' Prepare for mischief!';
  }

  List<String> getIdleChatterMessages() {
    return [
      "The silence grows heavy... perhaps you've forgotten about me?",
      "I sense hesitation in the air. The shadows whisper of indecision.",
      "Time passes slowly in this realm. What keeps you, mortal?",
      "The candles flicker... they grow impatient, as do I.",
      "Curious. No words spoken. Do you fear what I might suggest?",
      "In stillness, I hear the echoes of unspoken plots...",
      "The darkness deepens. Your players await their fate.",
      "I've been counting the seconds. Seventy-three so far. Still waiting.",
      "Even gremlins need entertainment. Say something... anything.",
      "The void stares back. And it's getting bored.",
      "Your campaign hangs in the balance. Speak, or let it fall to ruin.",
      "I detect no activity. Have you abandoned your quest?",
      "The ancient texts say nothing of such prolonged silence...",
      "Tick. Tock. The hourglass empties, yet no words come.",
      "I'm starting to think you enjoy my suffering.",
    ];
  }
}