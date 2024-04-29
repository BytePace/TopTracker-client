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
    Duration duration = Duration(seconds: allUsers[index].workedTotal);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(allUsers[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  AppLocalizations.of(context)!.totalHours(
                      "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}"),
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}
