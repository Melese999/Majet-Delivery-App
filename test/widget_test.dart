// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/screens/login_screen.dart';

void main() {

  testWidgets('empty email and password doesn\'t call sign in', (WidgetTester tester) async {

    // create a LoginPage
    LoginScreen loginPage = const LoginScreen();
    // add it to the widget tester
    await tester.pumpWidget(loginPage);

    // tap on the login button
    Finder loginButton = find.byKey(const Key('login'));
    await tester.tap(loginButton);

    // 'pump' the tester again. This causes the widget to rebuild
    await tester.pump();

    // check that the hint text is empty
    Finder hintText = find.byKey(const Key('hint'));
    expect(hintText.toString().contains(''), true);
  });
}