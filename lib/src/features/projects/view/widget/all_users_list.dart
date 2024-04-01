import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';

class AllUsersList extends StatelessWidget {
  final List<UserModel> allUsers;
  final int id;
  const AllUsersList({super.key, required this.allUsers, required this.id});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Все пользователи",
            style: Theme.of(context).textTheme.headlineMedium),
        Column(
          children: List.generate(
            allUsers.length,
            (index) => Padding(
              padding: const EdgeInsets.all(4),
              child: OutlinedButton(
                onPressed: () {
                  BlocProvider.of<DetailProjectBloc>(context).add(AddUSerEvent(
                      email: allUsers[index].email,
                      role: "worker",
                      rate: "",
                      projectID: id,
                      context: context));
                },
                child: ListTile(
                  dense: true,
                  title: Text(allUsers[index].name),
                  trailing: const Icon(Icons.add),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
