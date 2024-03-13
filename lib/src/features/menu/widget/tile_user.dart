import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';

class UserTile extends StatelessWidget {
  final UserModel userModel;
  final UserEngagementsModel userEngagementsModel;
  final Function() onTap;
  const UserTile({super.key, required this.userModel, required this.userEngagementsModel, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        children: [
          Text(userEngagementsModel.profileId.toString()),
          Text(userModel.name),
          Text(userModel.id.toString()),
          TextButton(
              onPressed: onTap,
              child: Text("delete user"))
        ],
      ),
    );
  }
}
