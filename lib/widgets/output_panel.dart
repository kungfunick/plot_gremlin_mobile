import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gremlin_provider.dart';
import '../theme/app_theme.dart';

class OutputPanel extends StatelessWidget {
  const OutputPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GremlinProvider>(
      builder: (context, gremlin, _) {
        return Card(
          child: Container(
            constraints: const BoxConstraints(minHeight: 300),
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Transcripts Section
                if (gremlin.transcripts.isNotEmpty) ...[
                  Text(
                    'RECENT TRANSCRIPTS',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 16),
                  ...gremlin.transcripts.map((transcript) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: AppTheme.borderRed,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        transcript,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppTheme.textMid.withOpacity(0.7),
                        ),
                      ),
                    );
                  }).toList(),
                  const Divider(height: 32),
                ],

                // Suggestion Section
                if (gremlin.lastSuggestion != null) ...[
                  Text(
                    'THE GREMLIN SPEAKS',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: AppTheme.bloodLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.bloodRed.withOpacity(0.1),
                      border: Border.all(
                        color: AppTheme.borderRed,
                      ),
                    ),
                    child: Text(
                      gremlin.lastSuggestion!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ] else if (gremlin.transcripts.isEmpty) ...[
                  // Empty state
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'The shadows stir... awaiting your command',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppTheme.textDim,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],

                // Loading state
                if (gremlin.isGenerating) ...[
                  const SizedBox(height: 24),
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.bloodRed,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'The Gremlin contemplates...',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppTheme.textDim,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}