import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/app.dart';

import 'package:tt_bytepace/src/features/login/models/login_model.dart';
import 'package:tt_bytepace/src/features/login/services/auth_service.dart';
import 'package:tt_bytepace/src/features/login/view/login_screen.dart';

void main() {
  testWidgets("Login screen test", (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: App(authProvider: MockAuthService())));

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
    await tester.pump();
    var appbar = find.byType(LoginScreen);
    expect(appbar, findsOneWidget);
  });
}

class MockAuthService extends AuthService {
  @override
  void setUser(LoginModel user) {
    this.user = user;
  }

  @override
  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("access_token"));
    return prefs.getString("access_token") ?? "";
  }

  @override
  bool get isAuthorized {
    return user.access_token.isNotEmpty;
  }

  @override
  Future<void> login(String email, String password) async {
    print("MockAuthServices login");
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call
      final response = {
        "access_token":
            "bjMrM09Mc0g1Ui9yeDV3bXVFM2xhbTdIM0xFSnhuMEhEc2U4VlNvWWFoTTR3SEJ2QktsZXFHUmgzbG1LcGFkbC0tNTNPMEJ2Um1IUFVkNXZEM3ZpTjZtUT09--76db87bb16d9423492354db5ecbebcf5d4c3bbe4",
        "user": {
          "id": 347810,
          "email": "aleksandr.sherbakov@bytepace.com",
          "name": "Aleksandr Sherbakov",
        },
      };

      return Response(jsonEncode(response), 201, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      });
    });

    final response = await mockHTTPClient.get(Uri.base);
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setUser(LoginModel.fromJson(responseData));

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", responseData['access_token']);

      notifyListeners();
      print("end auth login");
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }
}
