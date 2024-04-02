import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/tile_user.dart';
import 'package:tt_bytepace/src/resources/text.dart';

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
        Text(CustomText.userOnProjectText,
            style: Theme.of(context).textTheme.headlineMedium),
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
