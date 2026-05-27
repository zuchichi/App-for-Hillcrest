import 'package:flutter_test/flutter_test.dart';

import 'package:app_for_hillcrest/app.dart';

void main() {
  testWidgets('Intro page shows Get Started', (WidgetTester tester) async {
    await tester.pumpWidget(const HillcrestRidesApp());

    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Hillcrest Ride Request'), findsOneWidget);
  });
}
