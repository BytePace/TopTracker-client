import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';
import 'package:tt_bytepace/src/features/menu/widget/tile_user.dart';

class UserOnProject extends StatelessWidget {
  final DetailProjectModel detailProjectModel;
  final UserServices state;
  const UserOnProject(
      {super.key, required this.detailProjectModel, required this.state});



  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: List.generate(
          detailProjectModel.engagements.length,
          (index) => UserTile(
            detailProjectModel: detailProjectModel,
            index: index,
          ),
        ),
      ),
    );
  }
}
