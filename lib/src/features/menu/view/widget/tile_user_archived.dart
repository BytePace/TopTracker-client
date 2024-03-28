import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';

class UserTileArchived extends StatelessWidget {
  final DetailProjectModel detailProjectModel;
  final List<ProfileID> allUsers;
  final int index;

  const UserTileArchived(
      {super.key,
      required this.detailProjectModel,
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
          Text(
              "Total hours: ${(detailProjectModel.engagements[index].workedTotal / 60 / 60).round()}"),
          detailProjectModel.currentUserRole == "admin"
              ? PopupMenuButton(itemBuilder: (context) {
                  return [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text(""),
                    ),
                  ];
                }, onSelected: (value) {
                  if (value == 0) {}
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
