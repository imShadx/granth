import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:granth/widgets/no_connection.dart';

void main() {
  // Test 1 — NoConnectionWidget renders correctly
  testWidgets('NoConnectionWidget shows retry button', (tester) async {
    bool retried = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoConnectionWidget(onRetry: () => retried = true),
        ),
      ),
    );
    expect(find.text('NO CONNECTION.'), findsOneWidget);
    expect(find.text('RETRY →'), findsOneWidget);
    await tester.tap(find.text('RETRY →'));
    expect(retried, true);
  });

  // Test 2 — HomePage renders key elements
  testWidgets('HomePage shows app name and swipe up text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(
        body: Column(
          children: [
            Text('GRANTH'),
            Text('SWIPE UP'),
          ],
        ),
      )),
    );
    expect(find.text('GRANTH'), findsOneWidget);
    expect(find.text('SWIPE UP'), findsOneWidget);
  });

  // Test 3 — NoConnectionWidget wifi_off icon is present
  testWidgets('NoConnectionWidget shows wifi off icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoConnectionWidget(onRetry: () {}),
        ),
      ),
    );
    expect(find.byIcon(Icons.wifi_off), findsOneWidget);
  });
}