import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flight_automation_system/main.dart';
import 'package:flight_automation_system/localization.dart';

///the main entry point for the localization tests
void main() {
  testWidgets('App localization test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    /// test English localization
    await tester.binding.setLocale('en', 'US');
    await tester.pumpAndSettle();

    expect(find.text('Airline Management'), findsOneWidget);

    /// test French localization
    await tester.binding.setLocale('fr', 'FR');
    await tester.pumpAndSettle();

    ///verification for the "Gestion de Compagnie Aérienne" is found in the widget tree.
    expect(find.text('Gestion de Compagnie Aérienne'), findsOneWidget);
  });
}
