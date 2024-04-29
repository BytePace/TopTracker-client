import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/login/bloc/auth_bloc.dart';
import 'package:tt_bytepace/src/resources/constant_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authBloc = GetIt.I<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              const SizedBox(height: ConstantSize.bigSeparatorHeight),

              //logo
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'lib/src/resources/assets/playstore-icon.png',
                  width: 150,
                  height: 150,
                ),
              ),

              const SizedBox(height: ConstantSize.bigSeparatorHeight),

              //welcome message
              Text(
                AppLocalizations.of(context)!.welcomeMessageText,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: ConstantSize.bigSeparatorHeight),

              //emailTextField
              TextField(
                style: Theme.of(context).textTheme.labelMedium,
                autocorrect: false,
                controller: emailController,
                key: const Key('emailTextField'),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.hintEmailText,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Colors.grey),
                ),
              ),

              const SizedBox(height: ConstantSize.defaultSeparatorHeight),

              //PasswordTextField
              TextField(
                style: Theme.of(context).textTheme.labelMedium,
                controller: passwordController,
                obscureText: !isPasswordVisible,
                key: const Key('passwordTextField'),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.hintPasswordText,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
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
    );
  }
}
