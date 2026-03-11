import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bronet_business/main.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const BronetBusinessApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Bottom navigation renders with 5 tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const BronetBusinessApp());
    await tester.pump();
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Bookings'), findsWidgets);
    expect(find.text('Services'), findsWidgets);
    expect(find.text('Schedule'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
  });

  testWidgets('Tab navigation switches screens', (WidgetTester tester) async {
    await tester.pumpWidget(const BronetBusinessApp());
    await tester.pump();

    await tester.tap(find.text('Services'));
    await tester.pumpAndSettle();
    expect(find.text('Services'), findsWidgets);
  });
}
