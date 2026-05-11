import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_revive_ai/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full app flow: onboarding -> home', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: PhotoReviveApp()),
    );
    await tester.pumpAndSettle();

    // Should show onboarding or home depending on state
    // For first launch, should show onboarding
    final skipButton = find.text('Skip');
    if (skipButton.evaluate().isNotEmpty) {
      // We're on onboarding
      await tester.tap(skipButton);
      await tester.pumpAndSettle();
    }

    // Should now be on home
    expect(find.text('PhotoRevive AI'), findsOneWidget);
    expect(find.text('Enhance'), findsOneWidget);
    expect(find.text('Restore Face'), findsOneWidget);
    expect(find.text('Colorize'), findsOneWidget);
  });
}
