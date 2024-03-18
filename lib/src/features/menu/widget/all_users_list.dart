import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';

class AllUsersList extends StatelessWidget {
  final List<AllUsers> allUsers;
  final int id;
  const AllUsersList({super.key, required this.allUsers, required this.id});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserServices>(context);

    return Column(
      children: List.generate(
        allUsers.length,
        (index) => Padding(
          padding:  const EdgeInsets.all(4),
          child: OutlinedButton(
            onPressed: () {
              viewModel.addUser(allUsers[index].email, "", "worker", id, context);
            },
            child: ListTile(
              dense: true,
              title: Text(allUsers[index].name),
              trailing: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
