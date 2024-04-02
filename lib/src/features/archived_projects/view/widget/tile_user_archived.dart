import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';

class UserTileArchived extends StatelessWidget {
  final List<UserModel> allUsers;
  final int index;

  const UserTileArchived(
      {super.key, required this.index, required this.allUsers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text(allUsers[index].name,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
