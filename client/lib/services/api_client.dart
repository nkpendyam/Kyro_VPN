import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class ApiClient {
  static const String baseUrl = 'https://kyrovpn.is-a.dev';
  final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient()
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )),
        _storage = const FlutterSecureStorage() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? deviceId = await _storage.read(key: 'device_id');
          if (deviceId == null) {
            deviceId = const Uuid().v4();
            await _storage.write(key: 'device_id', value: deviceId);
          }
          options.headers['X-Device-Id'] = deviceId;
          return handler.next(options);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getBestNode() async {
    try {
      final response = await _dio.get('/nodes/best');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch best node: $e');
    }
  }

  Future<Map<String, dynamic>> getCredits() async {
    try {
      final response = await _dio.get('/auth/credits');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch credits: $e');
    }
  }

  Future<List<dynamic>> fetchNodes() async {
    try {
      final response = await _dio.get('/nodes');
      return response.data['nodes'] as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch nodes: $e');
    }
  }

  Future<String> getConfig(String nodeId, String clientPubKey) async {
    try {
      final response = await _dio.post('/vpn/config', data: {
        'node_id': nodeId,
        'client_pubkey': clientPubKey,
      });
      return response.data['config'] as String;
    } catch (e) {
      throw Exception('Failed to fetch VPN config: $e');
    }
  }
}
