sealed class VpnState {
  const VpnState();
}

class Disconnected extends VpnState {
  const Disconnected();
}

class Connecting extends VpnState {
  const Connecting();
}

class Connected extends VpnState {
  final String nodeId;
  final DateTime since;
  const Connected({required this.nodeId, required this.since});
}

class VpnError extends VpnState {
  final String message;
  const VpnError(this.message);
}
