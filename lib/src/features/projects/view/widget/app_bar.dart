import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tt_bytepace/src/features/login/bloc/auth_bloc.dart';
import 'package:tt_bytepace/src/features/utils/alert_dialog.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  int currentTub = 0;
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            key: const Key("appbar"),
            currentTub == 0
                ? "Projects"
                : currentTub == 1
                    ? "Archived Projects"
                    : "Users"),
        TextButton(
          child: const Text("logout"),
          onPressed: () => showDialog<void>(
            context: context,
            builder: (ctx) => MyAlertDialog(
              ctx: context,
              title: "Log Out",
              content: "Are you sure want to log out?",
              isYes: TextButton(
                onPressed: () {
                  authBloc.add(LogOutEvent(context: ctx));
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
