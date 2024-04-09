import 'package:sqflite/sqlite_api.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/savable_project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';

class DbProjectDataSourceTest implements ISavableProjectDataSource {
  final Future<Database> _database;
  const DbProjectDataSourceTest({required Future<Database> database})
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
    final List<UserDto> userInfo = [];

    final List<Map<String, dynamic>> detailProjectsMapList =
        await database.query("DetailProject", where: keyArg, whereArgs: [id]);
    for (var project in detailProjectsMapList) {
      final List<Map<String, dynamic>> userInfoMapList =
          await database.query("UserInfo", where: keyArg, whereArgs: [id]);
      for (var info in userInfoMapList) {
        userInfo.add(UserDto.fromMap(info));
      }

      final List<Map<String, dynamic>> userEngagementsMapList = await database
          .query("UserEngagements", where: keyArg, whereArgs: [id]);
      for (var info in userEngagementsMapList) {
        userEngagementsDto.add(UserEngagementsDto.fromMap(info));
      }

      final List<Map<String, dynamic>> invitesMapList =
          await database.query("Invites", where: keyArg, whereArgs: [id]);
      for (var info in invitesMapList) {
        invitations.add(InvitedDto.fromMap(info));
      }

      detailProjectsList = DetailProjectDto.fromMap(
          project, userInfo, invitations, userEngagementsDto);
    }
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
      'UsersProfileID',
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

    final List<Map<String, dynamic>> projectsMapList =
        await database.query("Projects");

    for (var project in projectsMapList) {
      final List<int> list = [];
      final List<Map<String, dynamic>> userInfoMapList = await database.query(
          "UsersProfileID",
          distinct: true,
          where: keyArg,
          whereArgs: [project['id']]);
      for (var info in userInfoMapList) {
        list.add(info["profile_id"]);
      }
      projectList.add(ProjectDto.fromMap(project, list));
    }
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
  }

  @override
  Future<void> updateProject(List<ProjectModel> projects) async {
    final database = await _database;
    final batch = database.batch();
    batch.delete("Projects");
    batch.delete("UsersProfileID");
    await batch.commit();
    for (var project in projects) {
      batch.insert('Projects', project.toMap());
      for (var user in project.profilesIDs) {
        batch.insert('UsersProfileID',
            {"profile_id": user, "detail_project_id": project.id});
      }
    }
    await batch.commit();
  }

  @override
  Future<void> updateDetailProject(DetailProjectDto detailProjects) async {
    final database = await _database;
    final batch = database.batch();
    batch.delete("DetailProject",
        where: 'detail_project_id = ?', whereArgs: [detailProjects.id]);
    batch.delete("Invites",
        where: 'detail_project_id = ?', whereArgs: [detailProjects.id]);
    batch.delete("UserEngagements",
        where: 'detail_project_id = ?', whereArgs: [detailProjects.id]);
    await batch.commit();
    batch.insert('DetailProject', detailProjects.toMap());
    for (var user in detailProjects.users) {
      batch.insert('UserInfo', user.toMap(detailProjects.id));
    }
    for (var invite in detailProjects.invitations) {
      batch.insert('Invites', invite.toMap(detailProjects.id));
    }
    for (var userEngagement in detailProjects.engagements) {
      batch.insert('UserEngagements', userEngagement.toMap(detailProjects.id));
    }

    await batch.commit();
  }

  @override
  Future<void> archiveProject(int projectID) async {
    final database = await _database;
    await database.update(
      'Projects',
      {'archivedAt': "2024-04-09"},
      where: 'id = ?',
      whereArgs: [projectID],
    );
    //await database.close();
  }

  @override
  Future<void> dropDB() async {
    final database = await _database;
    await database.delete('UserEngagements');
    await database.delete('Invites');
    await database.delete('UserInfo');
    await database.delete('UsersProfileID');
    await database.delete('DetailProject');
    await database.delete('Projects');
  }
}