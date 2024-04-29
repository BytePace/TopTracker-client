import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/user_model.dart';
import 'package:tt_bytepace/src/features/utils/alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserTile extends StatelessWidget {
  final DetailProjectModel detailProjectModel;
  final List<UserInfoModel> allUsers;
  final int index;

  const UserTile(
      {super.key,
      required this.detailProjectModel,
      required this.index,
      required this.allUsers});

  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(seconds: allUsers[index].workedTotal);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(allUsers[index].name,
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          Row(
            children: [
              Text(AppLocalizations.of(context)!.totalHours(
                  "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}")),
              detailProjectModel.currentUserRole == "admin"
                  ? PopupMenuButton(itemBuilder: (context) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text(
                            AppLocalizations.of(context)!.deleteThisUser,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ];
                    }, onSelected: (value) {
                      if (value == 0) {
                        showDialog<void>(
                            context: context,
                            builder: (ctx) => MyAlertDialog(
                                  ctx: context,
                                  title: AppLocalizations.of(context)!
                                      .deleteThisUser,
                                  content: AppLocalizations.of(context)!
                                      .wantDeleteUser,
                                  isYes: TextButton(
                                      onPressed: () async {
                                        Navigator.of(ctx).pop();
                                        BlocProvider.of<DetailProjectBloc>(
                                                context)
                                            .add(DeleteUserEvent(
                                                projectID:
                                                    detailProjectModel.id,
                                                profileID:
                                                    allUsers[index].profileID));
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .deleteUser,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      )),
                                ));
                      }
                    })
                  : PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return [];
                      },
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
