import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tt_bytepace/src/features/login/bloc/auth_bloc.dart';
import 'package:tt_bytepace/src/resources/colors.dart';
import 'package:tt_bytepace/src/resources/text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    emailController.text = "";
    passwordController.text = "";

    return Scaffold(
      backgroundColor: CustomColors.greyColor[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                //logo
                Icon(
                  Icons.message,
                  size: 80,
                  color: Colors.grey[800],
                ),

                const SizedBox(height: 50),

                //welcome message
                const Text(
                  DisplayText.welcomeMessageText,
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 50),

                //emailTextField
                TextField(
                  controller: emailController,
                  key: const Key('emailTextField'),
                ),

                const SizedBox(height: 10),

                //PasswordTextField
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  key: const Key('passwordTextField'),
                ),

                const SizedBox(height: 10),

                TextButton(
                  child: const Text(DisplayText.loginButtonText),
                  onPressed: () {
                    authBloc.add(LogInEvent(
                        email: emailController.text,
                        password: passwordController.text));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
