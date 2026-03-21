import 'package:flutter/services.dart';

class TunnelService {
  static const MethodChannel _channel = MethodChannel('com.kyrovpn/vpn');

  Future<bool> startVpn({
    required String serverPublicKey,
    required String endpoint,
    required String localAddress,
    required String dns,
  }) async {
    try {
      final bool? result = await _channel.invokeMethod('startVpn', {
        'serverPublicKey': serverPublicKey,
        'endpoint': endpoint,
        'localAddress': localAddress,
        'dns': dns,
        'jc': 4,
        'jmin': 40,
        'jmax': 70,
        's1': 5,
        's2': 10,
        'h1': 1,
        'h2': 2,
        'h3': 3,
        'h4': 4,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      print("Failed to start VPN: '${e.message}'.");
      return false;
    }
  }

  Future<void> stopVpn() async {
    try {
      await _channel.invokeMethod('stopVpn');
    } on PlatformException catch (e) {
      print("Failed to stop VPN: '${e.message}'.");
    }
  }

  Future<String> getStatus() async {
    try {
      final String? status = await _channel.invokeMethod('getStatus');
      return status ?? 'disconnected';
    } on PlatformException {
      return 'error';
    }
  }
}
