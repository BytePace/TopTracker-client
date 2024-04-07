import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/utils/methods.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/add_user_form.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/all_users_list.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/invited_on_project.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/user_on_project.dart';

class ProjectInfoScreen extends StatefulWidget {
  final int id;
  final String name;
  final List<UserModel> allUsers;
  const ProjectInfoScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.allUsers});

  @override
  State<ProjectInfoScreen> createState() => _ProjectInfoScreenState();
}

class _ProjectInfoScreenState extends State<ProjectInfoScreen> {
  @override
  void initState() {
    BlocProvider.of<DetailProjectBloc>(context)
        .add(LoadDetailProjectEvent(projectID: widget.id));
    super.initState();
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView(
                  children: [
                    UserOnProject(
                        key: UniqueKey(),
                        detailProjectModel: state.detailProjectModel,
                        allUsers: getListUsersOnProject(
                            state.detailProjectModel.engagements,
                            widget.allUsers)),
                    const SizedBox(height: 16),
                    InvitedOnProject(
                      key: UniqueKey(),
                      detailProjectModel: state.detailProjectModel,
                    ),
                    const SizedBox(height: 16),
                    AddUserForm(id: widget.id),
                    const SizedBox(height: 16),
                    AllUsersList(
                        allUsers: getAllUsersWhithoutOnProject(
                            state.detailProjectModel.engagements,
                            widget.allUsers),
                        id: widget.id),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
