import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/users/services/users_services.dart';
import 'package:tt_bytepace/src/features/utils/alert_dialog.dart';

class UserTile extends StatelessWidget {
  final DetailProjectModel detailProjectModel;
  final List<UserModel> allUsers;
  final int index;

  const UserTile(
      {super.key,
      required this.detailProjectModel,
      required this.index,
      required this.allUsers});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserServices>(context);

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
                      child: Text("Delete user"),
                    ),
                  ];
                }, onSelected: (value) {
                  if (value == 0) {
                    showDialog<void>(
                        context: context,
                        builder: (ctx) => MyAlertDialog(
                              ctx: context,
                              title: "Delete user",
                              content: "Are you sure want to delete this user?",
                              isYes: TextButton(
                                  onPressed: () async {
                                    Navigator.of(ctx).pop();
                                    await viewModel.delUser(detailProjectModel.id,
                                        allUsers[index].profileID, context);
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ));
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
