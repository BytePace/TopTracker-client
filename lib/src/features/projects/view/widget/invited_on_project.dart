import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/resources/constant_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvitedOnProject extends StatelessWidget {
  final DetailProjectModel detailProjectModel;
  const InvitedOnProject({super.key, required this.detailProjectModel});

  @override
  Widget build(BuildContext context) {
    return detailProjectModel.invitations.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.invitedUsersText,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: ConstantSize.defaultSeparatorHeight),
              Column(
                children: List.generate(
                  detailProjectModel.invitations.length,
                  (index) => OutlinedButton(
                    style:  Theme.of(context).outlinedButtonTheme.style,
                    onPressed: () {
                      BlocProvider.of<DetailProjectBloc>(context).add(
                          RevokeInviteEvent(
                              invitationsID: detailProjectModel
                                  .invitations[index].inviteID,
                              projectID: detailProjectModel.id));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            detailProjectModel.invitations[index].name ??
                                "name",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 14)),
                        const Icon(Icons.remove_circle_outline)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}
