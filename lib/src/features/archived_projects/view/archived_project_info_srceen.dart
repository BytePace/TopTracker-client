import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/bloc/project_bloc/project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/projects/utils/methods.dart';
import 'package:tt_bytepace/src/features/utils/alert_dialog.dart';
import 'package:tt_bytepace/src/features/archived_projects/view/widget/tile_user_archived.dart';
import 'package:tt_bytepace/src/resources/constant_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArchivedProjectInfoScreen extends StatefulWidget {
  final int id;
  final String name;
  final ProjectModel project;
  final List<UserModel> allUsers;
  const ArchivedProjectInfoScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.allUsers,
      required this.project});

  @override
  State<ArchivedProjectInfoScreen> createState() =>
      _ArchivedProjectInfoScreenState();
}

class _ArchivedProjectInfoScreenState extends State<ArchivedProjectInfoScreen> {
  @override
  void initState() {
    BlocProvider.of<DetailProjectBloc>(context)
        .add(LoadDetailProjectEvent(projectID: widget.id));
    super.initState();
  }

  void _restoreProject() {
    showDialog<void>(
      context: context,
      builder: (ctx) => MyAlertDialog(
        ctx: context,
        title: AppLocalizations.of(context)!.restoreProject,
        content: AppLocalizations.of(context)!.wantRestoreProject,
        isYes: TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              GetIt.I<ProjectBloc>().add(RestoreProjectEvent(id: widget.id));
            },
            child: Text(
              AppLocalizations.of(context)!.restore,
              style: Theme.of(context).textTheme.labelMedium,
            )),
      ),
    );
  }

  void _deleteProject() {
    showDialog<void>(
      context: context,
      builder: (ctx) => MyAlertDialog(
        ctx: context,
        title: AppLocalizations.of(context)!.deleteProject,
        content: AppLocalizations.of(context)!.wantDeleteProject,
        isYes: TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              GetIt.I<ProjectBloc>().add(DeleteProjectEvent(id: widget.id));
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: Theme.of(context).textTheme.labelMedium,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: BlocBuilder<DetailProjectBloc, DetailProjectState>(
        bloc: BlocProvider.of<DetailProjectBloc>(context),
        builder: (context, state) {
          if (state is DetailProjectListLoaded) {
            final allUsers = getListUsersOnProject(
                state.detailProjectModel.engagements,
                state.detailProjectModel.users);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView(
                children: [
                  Card(
                    child: Column(
                      children: List.generate(
                          allUsers.length,
                          (index) => UserTileArchived(
                                index: index,
                                allUsers: allUsers,
                              )),
                    ),
                  ),
                  const SizedBox(height: ConstantSize.defaultSeparatorHeight),
                  widget.project.currentUser == "admin" ||
                          widget.project.currentUser == "supervisor"
                      ? Column(
                          children: [
                            OutlinedButton(
                                onPressed: _restoreProject,
                                child:  Text(AppLocalizations.of(context)!
                                    .restoreProject)),
                            const SizedBox(
                                height: ConstantSize.defaultSeparatorHeight),
                            OutlinedButton(
                                onPressed: _deleteProject,
                                child:  Text(AppLocalizations.of(context)!
                                    .deleteProject))
                          ],
                        )
                      : Container()
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
