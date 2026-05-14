import 'package:flutter_test/flutter_test.dart';
import 'package:food_ordering_app/utils/app_state.dart';
import 'package:food_ordering_app/app.dart';

void main() {
  testWidgets('App smoke test — renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AppState(child: MyApp()));
    // The splash screen should show the app name
    expect(find.text('FoodDash'), findsOneWidget);
  });
}
