import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/src/features/login/view/login_screen.dart';
import 'package:test_app/src/features/menu/view/menu_screen.dart';
import 'package:test_app/src/features/services/auth_services.dart';

class App extends StatelessWidget {
  const App({super.key});


  @override
  Widget build(BuildContext context) {
    
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthState()),
        // other providers
      ],
      builder: (context, child) => Scaffold(
        body: Consumer<AuthState>(builder: (context, authState, _) {
          
          return authState.isAuthorized ? MenuScreen() : LoginScreen();
        }),
      ),
    );
  }
}
