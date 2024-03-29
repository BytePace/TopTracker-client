import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/users/view/widget/tile_user.dart';

class UserOnProject extends StatelessWidget {
  final DetailProjectModel detailProjectModel;
  final List<UserModel> allUsers;
  const UserOnProject(
      {super.key, required this.detailProjectModel, required this.allUsers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Пользователи на проекте", style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: List.generate(
              allUsers.length,
              (index) => UserTile(
                allUsers: allUsers,
                detailProjectModel: detailProjectModel,
                index: index,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
