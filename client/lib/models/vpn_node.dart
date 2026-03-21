class VpnNode {
  final String id;
  final String publicKey;
  final String endpoint;
  final String city;
  final String countryCode;

  VpnNode({
    required this.id,
    required this.publicKey,
    required this.endpoint,
    required this.city,
    required this.countryCode,
  });

  factory VpnNode.fromJson(Map<String, dynamic> json) {
    return VpnNode(
      id: json['node_id'] ?? '',
      publicKey: json['public_key'] ?? '',
      endpoint: json['endpoint'] ?? '',
      city: json['city'] ?? 'Unknown',
      countryCode: json['country_code'] ?? '??',
    );
  }
}
