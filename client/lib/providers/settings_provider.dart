import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/kyro_settings.dart';

part 'settings_provider.g.dart';

@riverpod
class Settings extends _$Settings {
  static const _key = 'kyro_settings';

  @override
  KyroSettings build() {
    // We return a default and then load asynchronously.
    // In a real app, you might want to wait for SharedPreferences in main() 
    // and provide it via a provider.
    _load();
    return const KyroSettings();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      state = KyroSettings.fromJson(jsonDecode(jsonString));
    }
  }

  Future<void> update(KyroSettings newSettings) async {
    state = newSettings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(newSettings.toJson()));
  }

  void setKillSwitch(bool value) => update(state.copyWith(killSwitch: value));
  void setDnsLeakProtection(bool value) => update(state.copyWith(dnsLeakProtection: value));
  void setBlockIpv6(bool value) => update(state.copyWith(blockIpv6: value));
  void setThemeMode(String value) => update(state.copyWith(themeMode: value));
}
