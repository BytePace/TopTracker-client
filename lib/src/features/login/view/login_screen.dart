import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tt_bytepace/src/features/login/bloc/auth_bloc.dart';
import 'package:tt_bytepace/src/resources/colors.dart';
import 'package:tt_bytepace/src/resources/constant_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                const SizedBox(height: ConstantSize.bigSeparatorHeight),
                //logo
                Icon(
                  Icons.message,
                  size: 80,
                  color: Colors.grey[800],
                ),

                const SizedBox(height: ConstantSize.bigSeparatorHeight),

                //welcome message
                Text(
                  AppLocalizations.of(context)!.welcomeMessageText,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: ConstantSize.bigSeparatorHeight),

                //emailTextField
                TextField(
                  controller: emailController,
                  key: const Key('emailTextField'),
                ),

                const SizedBox(height: ConstantSize.defaultSeparatorHeight),

                //PasswordTextField
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  key: const Key('passwordTextField'),
                ),

                const SizedBox(height: ConstantSize.defaultSeparatorHeight),

                TextButton(
                  child: Text(AppLocalizations.of(context)!.loginButtonText),
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
