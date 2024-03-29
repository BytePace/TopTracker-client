import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/users/services/users_services.dart';

class InvitedOnProject extends StatelessWidget {
  final DetailProjectModel detailProjectModel;
  const InvitedOnProject({super.key, required this.detailProjectModel});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserServices>(context);
    return detailProjectModel.invitations.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Приглашенные пользователи",
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              Column(
                children: List.generate(
                  detailProjectModel.invitations.length,
                  (index) => OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.green[100]),
                    onPressed: () {
                      viewModel.revokeInvite(
                          detailProjectModel.invitations[index].inviteID,
                          context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(detailProjectModel.invitations[index].name ??
                            "name"),
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
