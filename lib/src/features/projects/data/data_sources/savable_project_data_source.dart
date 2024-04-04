import 'package:sqflite/sqlite_api.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/project_dto.dart';

import '../../model/dto/detail_project_dto.dart';

abstract interface class ISavableProjectDataSource {
  Future<DetailProjectDto> getDetailProject(int id);

  Future<List<ProjectDto>> getProjects();

  Future<void> restoreProject(int projectID);

  Future<void> deleteProject(int projectID);
}

class DbProjectDataSource implements ISavableProjectDataSource {
  final Future<Database> _database;
  const DbProjectDataSource({required Future<Database> database})
      : _database = database;

  @override
  Future<DetailProjectDto> getDetailProject(int id) async {
    final database = await _database;
    const keyArg = "detail_project_id = ?";

    DetailProjectDto detailProjectsList = const DetailProjectDto(
      users: [],
      invitations: [],
      id: 0,
      name: '',
      engagements: [],
      currentUserRole: '',
    );

    final List<UserEngagementsDto> userEngagementsDto = [];
    final List<InvitedDto> invitations = [];
    final List<UserInfoDto> userInfo = [];

    final List<Map<String, dynamic>> detailProjectsMapList =
        await database.query("DetailProject", where: keyArg, whereArgs: [id]);
    detailProjectsMapList.forEach((project) async {
      final List<Map<String, dynamic>> userInfoMapList =
          await database.query("UserInfo", where: keyArg, whereArgs: [id]);
      print(project);

      userInfoMapList.forEach((info) {
        print(info);
        userInfo.add(UserInfoDto.fromMap(info));
      });

      final List<Map<String, dynamic>> userEngagementsMapList = await database
          .query("UserEngagements", where: keyArg, whereArgs: [id]);
      print(project);

      userEngagementsMapList.forEach((info) {
        print(info);
        userEngagementsDto.add(UserEngagementsDto.fromMap(info));
      });

      final List<Map<String, dynamic>> invitesMapList =
          await database.query("Invites", where: keyArg, whereArgs: [id]);
      print(project);

      invitesMapList.forEach((info) {
        print(info);
        invitations.add(InvitedDto.fromMap(info));
      });
      detailProjectsList = DetailProjectDto.fromMap(
          project, userInfo, invitations, userEngagementsDto);
    });
    print(detailProjectsMapList);
    //await database.close();
    return detailProjectsList;
  }

  @override
  Future<void> deleteProject(int projectID) async {
    final database = await _database;
    await database.delete(
      'UserEngagements',
      where: 'detail_project_id = ?',
      whereArgs: [projectID],
    );
    await database.delete(
      'Invites',
      where: 'detail_project_id = ?',
      whereArgs: [projectID],
    );
    await database.delete(
      'UserInfo',
      where: 'detail_project_id = ?',
      whereArgs: [projectID],
    );
    await database.delete(
      'Users',
      where: 'detail_project_id = ?',
      whereArgs: [projectID],
    );
    await database.delete(
      'DetailProject',
      where: 'detail_project_id = ?',
      whereArgs: [projectID],
    );
    await database.delete(
      'Projects',
      where: 'id = ?',
      whereArgs: [projectID],
    );
    //await database.close();
  }

  @override
  Future<List<ProjectDto>> getProjects() async {
    final database = await _database;
    const keyArg = "detail_project_id = ?";

    List<ProjectDto> projectList = [];
    final List<int> profileIDs = [];

    final List<Map<String, dynamic>> detailProjectsMapList =
        await database.query("Projects");

    for (var project in detailProjectsMapList) {
      print(project);
      final List<Map<String, dynamic>> userInfoMapList = await database
          .query("Users", where: keyArg, whereArgs: [project['id']]);
      print(project['id']);
      userInfoMapList.forEach((info) {
        profileIDs.add(info["profileID"]);
      });
      projectList.add(ProjectDto.fromMap(project, profileIDs));
    }

    print(projectList);
    //await database.close();
    return projectList;
  }

  @override
  Future<void> restoreProject(int projectID) async {
    final database = await _database;
    await database.update(
      'Projects',
      {'archivedAt': null},
      where: 'id = ?',
      whereArgs: [projectID],
    );
    //await database.close();
  }
}
