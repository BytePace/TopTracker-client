import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/user_model.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/tile_user.dart';
import 'package:tt_bytepace/src/resources/constant_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserOnProject extends StatelessWidget {
  final DetailProjectModel detailProjectModel;
  final List<UserInfoModel> allUsers;
  const UserOnProject(
      {super.key, required this.detailProjectModel, required this.allUsers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.userOnProjectText,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: ConstantSize.defaultSeparatorHeight),
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
