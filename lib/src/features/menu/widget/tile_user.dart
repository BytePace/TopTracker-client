import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';

class UserTile extends StatelessWidget {
  final DetailProjectModel detailProjectModel;
  final int index;

  const UserTile({
    super.key,
    required this.detailProjectModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserServices>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(detailProjectModel.users[index].name),
          Text(
              "Total hours: ${(detailProjectModel.engagements[index].workedTotal / 60 / 60).round()}"),
          detailProjectModel.currentUserRole == "admin"
              ? PopupMenuButton(itemBuilder: (context) {
                  return [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Delete user"),
                    ),
                  ];
                }, onSelected: (value) {
                  if (value == 0) {
                    viewModel.delUser(detailProjectModel.id,
                        detailProjectModel.users[index].id, context);
                  }
                })
              : PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text(""),
                      ),
                    ];
                  },
                ),
        ],
      ),
    );
  }
}
