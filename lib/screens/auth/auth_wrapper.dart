import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String _provider = 'offline';
  String _apiKey = '';
  int _aggregate = 5;
  bool _liveListen = true;
  bool _enableSound = false;
  bool _idleChatter = true;
  int _idleInterval = 30;

  SettingsProvider() {
    _loadSettings();
  }

  String get provider => _provider;
  String get apiKey => _apiKey;
  int get aggregate => _aggregate;
  bool get liveListen => _liveListen;
  bool get enableSound => _enableSound;
  bool get idleChatter => _idleChatter;
  int get idleInterval => _idleInterval;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _provider = prefs.getString('provider') ?? 'offline';
    _apiKey = prefs.getString('apiKey') ?? '';
    _aggregate = prefs.getInt('aggregate') ?? 5;
    _liveListen = prefs.getBool('liveListen') ?? true;
    _enableSound = prefs.getBool('enableSound') ?? false;
    _idleChatter = prefs.getBool('idleChatter') ?? true;
    _idleInterval = prefs.getInt('idleInterval') ?? 30;

    notifyListeners();
  }

  Future<void> updateProvider(String value) async {
    _provider = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('provider', value);
    notifyListeners();
  }

  Future<void> updateApiKey(String value) async {
    _apiKey = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiKey', value);
    notifyListeners();
  }

  Future<void> updateAggregate(int value) async {
    if (value < 1 || value > 20) return;
    _aggregate = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('aggregate', value);
    notifyListeners();
  }

  Future<void> updateLiveListen(bool value) async {
    _liveListen = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('liveListen', value);
    notifyListeners();
  }

  Future<void> updateEnableSound(bool value) async {
    _enableSound = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableSound', value);
    notifyListeners();
  }

  Future<void> updateIdleChatter(bool value) async {
    _idleChatter = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('idleChatter', value);
    notifyListeners();
  }

  Future<void> updateIdleInterval(int value) async {
    if (value < 5 || value > 300) return;
    _idleInterval = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('idleInterval', value);
    notifyListeners();
  }

  Future<void> saveAll({
    String? provider,
    String? apiKey,
    int? aggregate,
    bool? liveListen,
    bool? enableSound,
    bool? idleChatter,
    int? idleInterval,
  }) async {
    if (provider != null) _provider = provider;
    if (apiKey != null) _apiKey = apiKey;
    if (aggregate != null && aggregate >= 1 && aggregate <= 20) {
      _aggregate = aggregate;
    }
    if (liveListen != null) _liveListen = liveListen;
    if (enableSound != null) _enableSound = enableSound;
    if (idleChatter != null) _idleChatter = idleChatter;
    if (idleInterval != null && idleInterval >= 5 && idleInterval <= 300) {
      _idleInterval = idleInterval;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('provider', _provider);
    await prefs.setString('apiKey', _apiKey);
    await prefs.setInt('aggregate', _aggregate);
    await prefs.setBool('liveListen', _liveListen);
    await prefs.setBool('enableSound', _enableSound);
    await prefs.setBool('idleChatter', _idleChatter);
    await prefs.setInt('idleInterval', _idleInterval);

    notifyListeners();
  }
}