import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';

class UserTileArchived extends StatelessWidget {
  final List<ProfileIdModel> allUsers;
  final int index;

  const UserTileArchived(
      {super.key,
      required this.index,
      required this.allUsers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(allUsers[index].name),
        ],
      ),
    );
  }
}
