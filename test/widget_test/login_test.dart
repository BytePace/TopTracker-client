
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/login/services/auth_service.dart';
import 'package:tt_bytepace/src/features/login/view/login_screen.dart';

void main() {

  testWidgets("Login screen test", (WidgetTester tester) async {
    await tester.pumpWidget(ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
      child: const MaterialApp(home: LoginScreen()),
    ));
    var emailTextField = find.byKey(const Key('emailTextField'));
    var passwordTextField = find.byKey(const Key('passwordTextField'));
    expect(emailTextField, findsOneWidget);
    expect(passwordTextField, findsOneWidget);

    await tester.enterText(emailTextField, "aleksandr.sherbakov@bytepace.com");
    expect(find.text("aleksandr.sherbakov@bytepace.com"), findsOneWidget);

    await tester.enterText(passwordTextField, "aleksandr.sherb");
    expect(find.text("aleksandr.sherb"), findsOneWidget);

    var button = find.text("log in");
    expect(button, findsOneWidget);
    await tester.tap(button);
  });
}
