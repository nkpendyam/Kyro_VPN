import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/api_client.dart';

part 'api_provider.g.dart';

@riverpod
ApiClient apiClient(ref) => ApiClient();
