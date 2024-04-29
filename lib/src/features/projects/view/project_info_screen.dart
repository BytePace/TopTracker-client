import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/bloc/project_bloc/project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/utils/methods.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/add_user_form.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/add_work_time.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/all_users_list.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/invited_on_project.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/user_on_project.dart';
import 'package:tt_bytepace/src/features/utils/alert_dialog.dart';
import 'package:tt_bytepace/src/features/utils/methods.dart';
import 'package:tt_bytepace/src/resources/constant_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectInfoScreen extends StatefulWidget {
  final int id;
  final String name;
  final String role;
  final List<UserModel> allUsers;
  const ProjectInfoScreen(
      {super.key,
      required this.role,
      required this.id,
      required this.name,
      required this.allUsers});

  @override
  State<ProjectInfoScreen> createState() => _ProjectInfoScreenState();
}

class _ProjectInfoScreenState extends State<ProjectInfoScreen> {
  List<UserModel> _allUsers = [];
  @override
  void initState() {
    super.initState();
    _allUsers = widget.allUsers;
    BlocProvider.of<DetailProjectBloc>(context)
        .add(LoadDetailProjectEvent(projectID: widget.id));
  }

  void _archiveProject() {
    showDialog<void>(
      context: context,
      builder: (ctx) => MyAlertDialog(
        ctx: context,
        title: AppLocalizations.of(context)!.archiveProject,
        content: AppLocalizations.of(context)!.wantArchiveProject,
        isYes: TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              GetIt.I<ProjectBloc>().add(ArchiveProjectEvent(id: widget.id));
            },
            child: Text(
              AppLocalizations.of(context)!.archive,
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
      body: SafeArea(
        child: BlocListener<ProjectBloc, ProjectState>(
          bloc: GetIt.I<ProjectBloc>(),
          listener: (context, state) {
            if (state is ProjectListLoaded) {
              setState(() {
                _allUsers = state.allUser;
              });
            }
          },
          child: BlocConsumer<DetailProjectBloc, DetailProjectState>(
            bloc: BlocProvider.of<DetailProjectBloc>(context),
            builder: (context, state) {
              if (state is DetailProjectListLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView(
                    children: [
                      UserOnProject(
                          key: UniqueKey(),
                          detailProjectModel: state.detailProjectModel,
                          allUsers: getListUsersOnProject(
                              state.detailProjectModel.engagements,
                              state.detailProjectModel.users)),
                      const SizedBox(height: ConstantSize.defaultSeparatorHeight),
                      widget.role == "admin" ||  widget.role == "supervisor"
                          ? Column(
                              children: [
                                OutlinedButton(
                                    onPressed: _archiveProject,
                                    child: Text(AppLocalizations.of(context)!
                                        .archiveProject)),
                                const SizedBox(
                                    height: ConstantSize.defaultSeparatorHeight),
                                OutlinedButton(
                                    onPressed: _deleteProject,
                                    child: Text(AppLocalizations.of(context)!
                                        .deleteProject))
                              ],
                            )
                          : Container(),
                      const SizedBox(height: ConstantSize.defaultSeparatorHeight),
                      InvitedOnProject(
                        key: UniqueKey(),
                        detailProjectModel: state.detailProjectModel,
                      ),
                      const SizedBox(height: ConstantSize.defaultSeparatorHeight),
                      AddWorkTime(
                          projectID: widget.id,
                          key:
                              UniqueKey()), //панель добавления времени на проекте
                      const SizedBox(height: ConstantSize.defaultSeparatorHeight),
                      AddUserForm(
                          id: widget
                              .id), //панель добавления пользователя на проект
                      const SizedBox(height: ConstantSize.defaultSeparatorHeight),
                      AllUsersList(
                          key: UniqueKey(),
                          allUsers: getAllUsersWhithoutOnProject(
                              state.detailProjectModel.engagements, _allUsers),
                          id: widget.id),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
            listener: (BuildContext context, DetailProjectState state) {
              if (state is DetailProjectListMessage) {
                showSnackBar(context, state.message);
              }
            },
          ),
        ),
      ),
    );
  }
}
