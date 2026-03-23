import 'dart:developer';
import 'package:flutter/services.dart';
import '../core/amnezia_core.dart';

class TunnelService {
  static const MethodChannel _channel = MethodChannel('com.kyrovpn/vpn');

  Future<bool> startVpn({
    required String clientPrivateKey,
    required String serverPublicKey,
    required String endpoint,
    required String localAddress,
  }) async {
    try {
      final config = AmneziaCore.generateConfig(
        privateKey: clientPrivateKey,
        serverPublicKey: serverPublicKey,
        endpoint: endpoint,
        localAddress: localAddress,
      );
      
      return await AmneziaCore.startTunnel(config);
    } catch (e) {
      log("Failed to start VPN: '\$e'");
      return false;
    }
  }

  Future<void> stopVpn() async {
    try {
      await _channel.invokeMethod('stopVpn');
    } on PlatformException {
      log("Failed to stop VPN");
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
