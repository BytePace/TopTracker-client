import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/projects/model/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserTileArchived extends StatelessWidget {
  final List<UserInfoModel> allUsers;
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
            padding: const EdgeInsets.all(8.0),
            child: Text(allUsers[index].name,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                AppLocalizations.of(context)!.totalHours(
                    "${allUsers[index].workedTotal ~/ 3600}:${(allUsers[index].workedTotal ~/ 60) % 60}"),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
