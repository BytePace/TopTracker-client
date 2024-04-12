import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/login/bloc/auth_bloc.dart';
import 'package:tt_bytepace/src/features/profile/data/profile_repository.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/utils/alert_dialog.dart';

class ProfileScreen extends StatefulWidget {
  final List<ProjectModel> projects;
  const ProfileScreen({super.key, required this.projects});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileRepository = GetIt.I<ProfileRepository>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = GetIt.I<AuthBloc>();
    return BlocProvider<AuthBloc>(
      create: (context) => authBloc,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          "User Stats",
          style: Theme.of(context).textTheme.headlineSmall,
        )),
        body: FutureBuilder(
            future: _profileRepository.getStats(widget.projects),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("name: ${snapshot.data.name}",
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18)),
                              const SizedBox(height: 8),
                              Text(
                                  "curent week hours: ${double.parse((snapshot.data.workedTotal / 60 / 60).toStringAsFixed(2))}",
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (ctx) => MyAlertDialog(
                                ctx: context,
                                title: "Log Out",
                                content: "Are you sure want to log out?",
                                isYes: TextButton(
                                  onPressed: () {
                                    authBloc.add(LogOutEvent(context: ctx));
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Log Out",
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Text("logout"))
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
