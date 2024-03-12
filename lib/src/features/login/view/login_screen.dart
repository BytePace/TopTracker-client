import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/login/widget/button.dart';
import 'package:tt_bytepace/src/features/login/services/auth_services.dart';

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
    final viewModel = Provider.of<AuthState>(context);
    emailController.text = "aleksandr.sherbakov@bytepace.com";
    passwordController.text = "aleksandr.sherb";

    return Scaffold(
      backgroundColor: Colors.grey[300],
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
                  "text",
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 50),

                //emailTextField
                TextField(controller: emailController),

                const SizedBox(height: 10),

                //PasswordTextField
                TextField(controller: passwordController),

                const SizedBox(height: 10),

                TextButton(
                  child: Text("log in"),
                  onPressed: () {
                    viewModel.login(
                        emailController.text, passwordController.text);
                  },
                ),
                const SizedBox(height: 20),

                //register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a member?"),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Register Now",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
