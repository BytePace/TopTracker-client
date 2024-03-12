import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/login/services/auth_service.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authState, _) {
      return Center(
        child: TextButton(
          child: Text("logout"),
          onPressed: () {
            authState.logout();
          },
        ),
      );
    });
  }
}
