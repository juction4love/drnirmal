// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:drnirmal_app/main.dart';
import 'package:drnirmal_app/core/constants.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DrNirmalApp());

    // Verify that our app starts and displays Dr. Nirmal's name
    expect(find.text(AppConstants.drName), findsWidgets);
  });
}
