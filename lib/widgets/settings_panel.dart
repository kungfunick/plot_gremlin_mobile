import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';

class SettingsPanel extends StatefulWidget {
  final VoidCallback? onSave;

  const SettingsPanel({super.key, this.onSave});

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  late TextEditingController _apiKeyController;
  late TextEditingController _aggregateController;
  late TextEditingController _idleIntervalController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    _apiKeyController = TextEditingController(text: settings.apiKey);
    _aggregateController = TextEditingController(text: settings.aggregate.toString());
    _idleIntervalController = TextEditingController(text: settings.idleInterval.toString());
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _aggregateController.dispose();
    _idleIntervalController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final settings = context.read<SettingsProvider>();

    await settings.saveAll(
      apiKey: _apiKeyController.text,
      aggregate: int.tryParse(_aggregateController.text) ?? 5,
      idleInterval: int.tryParse(_idleIntervalController.text) ?? 30,
    );

    widget.onSave?.call();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuration saved'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Provider Dropdown
                DropdownButtonFormField<String>(
                  value: settings.provider,
                  decoration: const InputDecoration(
                    labelText: 'PROVIDER',
                  ),
                  dropdownColor: AppTheme.panelDark,
                  items: const [
                    DropdownMenuItem(value: 'offline', child: Text('Offline Gremlin')),
                    DropdownMenuItem(value: 'free', child: Text('Free API')),
                    DropdownMenuItem(value: 'openai', child: Text('OpenAI GPT')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      settings.updateProvider(value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // API Key
                TextField(
                  controller: _apiKeyController,
                  decoration: const InputDecoration(
                    labelText: 'API KEY',
                    hintText: 'sk-...',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                // Aggregate Count
                TextField(
                  controller: _aggregateController,
                  decoration: const InputDecoration(
                    labelText: 'AGGREGATE COUNT',
                    hintText: '1-20',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Idle Interval
                TextField(
                  controller: _idleIntervalController,
                  decoration: const InputDecoration(
                    labelText: 'IDLE CHATTER INTERVAL (seconds)',
                    hintText: '5-300',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                // Checkboxes
                CheckboxListTile(
                  title: const Text('LIVE LISTEN'),
                  value: settings.liveListen,
                  onChanged: (value) {
                    if (value != null) {
                      settings.updateLiveListen(value);
                    }
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppTheme.bloodRed,
                ),
                CheckboxListTile(
                  title: const Text('SOUND EFFECTS'),
                  value: settings.enableSound,
                  onChanged: (value) {
                    if (value != null) {
                      settings.updateEnableSound(value);
                    }
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppTheme.bloodRed,
                ),
                CheckboxListTile(
                  title: const Text('IDLE CHATTER'),
                  value: settings.idleChatter,
                  onChanged: (value) {
                    if (value != null) {
                      settings.updateIdleChatter(value);
                    }
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppTheme.bloodRed,
                ),
                const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  onPressed: _saveSettings,
                  child: const Text('SAVE CONFIGURATION'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}