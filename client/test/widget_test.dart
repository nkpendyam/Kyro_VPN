import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kyro_vpn/app.dart';

void main() {
  testWidgets('KyroApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: KyroApp(),
      ),
    );

    // Verify that the initial status is Disconnected
    expect(find.text('Disconnected'), findsOneWidget);
    expect(find.text('CONNECT'), findsOneWidget);
  });
}
