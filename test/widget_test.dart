// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flight_automation_system/main.dart';

void main() {
  testWidgets('MainPage buttons smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our buttons are displayed on the MainPage.
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Airplanes'), findsOneWidget);
    expect(find.text('Flight'), findsOneWidget);
    expect(find.text('Reservation'), findsOneWidget);

    // You can add more detailed tests here for each button and their navigation actions.
    // For example, to test the Airplanes button:

    await tester.tap(find.text('Airplanes'));
    await tester.pumpAndSettle(); // Wait for navigation

    // Verify that the AirplaneListPage is displayed.
    expect(find.text('Airplane List'), findsOneWidget);
  });
}
