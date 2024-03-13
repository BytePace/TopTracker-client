import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';
import 'package:tt_bytepace/src/features/menu/widget/tile_user.dart';

class ProjectInfoScreen extends StatelessWidget {
  final int id;
  final String name;
  const ProjectInfoScreen({super.key, required this.id, required this.name});

  void delUser(UserServices state, int index, DetailProjectModel data) async {
    state.delUser(data.id, data.engagements[index].profileId);
  }

  @override
  Widget build(BuildContext context) {
    final ProjectService projectService = ProjectService();
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Consumer<UserServices>(
          builder: (BuildContext context, UserServices state, Widget? child) {
        return FutureBuilder(
            future: projectService.getDetailProject(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  children: [
                    Column(
                        children: List.generate(
                          snapshot.data!.engagements.length,
                            (index) => UserTile(
                                userModel: snapshot.data!.users[index],
                                userEngagementsModel:
                                    snapshot.data!.engagements[index],
                                onTap: () {
                                  delUser(state, index, snapshot.data!);
                                }))),
                    TextButton(
                        onPressed: () async {
                          state.addUser("aleksandrsherbakov.2005@gmail.com", "",
                              "worker", id);
                        },
                        child: Text("add user"))
                  ],
                );
                // return Column(
                //   children: [
                //     ListView.builder(
                //         itemCount: snapshot.data!.engagements.length,
                //         itemBuilder: (context, index) {
                //           return UserTile(
                //             userModel: snapshot.data!.users[index],
                //             userEngagementsModel: snapshot.data!.engagements[index],
                //             onTap: () {
                //               delUser(state, index, snapshot.data!);
                //             },
                //           );
                //         }),
                //   ],
                // );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      }),
    );
  }
}
