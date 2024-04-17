import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/profile/view/profile_screen.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyAppBar extends StatelessWidget {
  final int currentTub;
  final List<ProjectModel> projects;
  const MyAppBar({super.key, required this.currentTub, required this.projects});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            key: const Key("appbar"),
            currentTub == 0
                ? AppLocalizations.of(context)!.bottomBarProjects
                : currentTub == 1
                    ? AppLocalizations.of(context)!.bottomBarArchivedProjects
                    : AppLocalizations.of(context)!.bottomBarUsers),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(projects: projects),
            ),
          ),
        )
      ],
    );
  }
}
