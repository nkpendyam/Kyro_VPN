// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConnectionNotifier)
final connectionProvider = ConnectionNotifierProvider._();

final class ConnectionNotifierProvider
    extends $NotifierProvider<ConnectionNotifier, VpnState> {
  ConnectionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionNotifierHash();

  @$internal
  @override
  ConnectionNotifier create() => ConnectionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VpnState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VpnState>(value),
    );
  }
}

String _$connectionNotifierHash() =>
    r'f1ff9bc2d960d28fdc268d1bd367f36f1b176279';

abstract class _$ConnectionNotifier extends $Notifier<VpnState> {
  VpnState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VpnState, VpnState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VpnState, VpnState>,
              VpnState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
