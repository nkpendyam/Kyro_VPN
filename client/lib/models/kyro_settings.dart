import 'package:flutter/material.dart';

class KyroSettings {
  final bool killSwitch;
  final bool dnsLeakProtection;
  final bool blockIpv6;
  final String themeMode; // 'System', 'Light', 'Dark'
  final String protocol;
  final String dnsServer;

  const KyroSettings({
    this.killSwitch = true,
    this.dnsLeakProtection = true,
    this.blockIpv6 = true,
    this.themeMode = 'System',
    this.protocol = 'AmneziaWG',
    this.dnsServer = '1.1.1.1',
  });

  KyroSettings copyWith({
    bool? killSwitch,
    bool? dnsLeakProtection,
    bool? blockIpv6,
    String? themeMode,
    String? protocol,
    String? dnsServer,
  }) {
    return KyroSettings(
      killSwitch: killSwitch ?? this.killSwitch,
      dnsLeakProtection: dnsLeakProtection ?? this.dnsLeakProtection,
      blockIpv6: blockIpv6 ?? this.blockIpv6,
      themeMode: themeMode ?? this.themeMode,
      protocol: protocol ?? this.protocol,
      dnsServer: dnsServer ?? this.dnsServer,
    );
  }

  Map<String, dynamic> toJson() => {
    'killSwitch': killSwitch,
    'dnsLeakProtection': dnsLeakProtection,
    'blockIpv6': blockIpv6,
    'themeMode': themeMode,
    'protocol': protocol,
    'dnsServer': dnsServer,
  };

  factory KyroSettings.fromJson(Map<String, dynamic> json) => KyroSettings(
    killSwitch: json['killSwitch'] ?? true,
    dnsLeakProtection: json['dnsLeakProtection'] ?? true,
    blockIpv6: json['blockIpv6'] ?? true,
    themeMode: json['themeMode'] ?? 'System',
    protocol: json['protocol'] ?? 'AmneziaWG',
    dnsServer: json['dnsServer'] ?? '1.1.1.1',
  );
}
