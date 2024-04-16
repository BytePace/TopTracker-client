import 'package:sqflite/sqlite_api.dart';
import 'package:tt_bytepace/src/database/database.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/invite_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_engagements_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';

import '../../model/dto/detail_project_dto.dart';

abstract interface class ISavableProjectDataSource {
  Future<DetailProjectDto> getDetailProject(int id);

  Future<List<ProjectDto>> getProjects();

  Future<void> restoreProject(int projectID);

  Future<void> deleteProject(int projectID);

  Future<void> archiveProject(int projectID);


  Future<void> updateProject(List<ProjectModel> projects);

  Future<void> updateDetailProject(DetailProjectDto detailProjects);
}

class DbProjectDataSource implements ISavableProjectDataSource {
  final Database _database;
  const DbProjectDataSource({required Database database})
      : _database = database;

  @override
  Future<DetailProjectDto> getDetailProject(int id) async {
    const keyArg = "${DbDetailProjectKeys.detailProjectID} = ?";

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
        await _database.query("DetailProject", where: keyArg, whereArgs: [id]);
    for (var project in detailProjectsMapList) {
      final List<Map<String, dynamic>> userInfoMapList =
          await _database.query("UserInfo", where: keyArg, whereArgs: [id]);
      for (var info in userInfoMapList) {
        userInfo.add(UserDto.fromUserInfoMap(info));
      }

      final List<Map<String, dynamic>> userEngagementsMapList = await _database
          .query("UserEngagements", where: keyArg, whereArgs: [id]);
      for (var info in userEngagementsMapList) {
        userEngagementsDto.add(UserEngagementsDto.fromMap(info));
      }

      final List<Map<String, dynamic>> invitesMapList =
          await _database.query("Invites", where: keyArg, whereArgs: [id]);
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
    await _database.delete(
      'UserEngagements',
      where: '${DbUserEngagementsKeys.detailProjectID} = ?',
      whereArgs: [projectID],
    );
    await _database.delete(
      'Invites',
      where: '${DbInvitesKeys.detailProjectID} = ?',
      whereArgs: [projectID],
    );
    await _database.delete(
      'UserInfo',
      where: '${DbUserInfoKeys.detailProjectID} = ?',
      whereArgs: [projectID],
    );
    await _database.delete(
      'UsersProfileID',
      where: '${DbUsersProfileIDKeys.detailProjectID} = ?',
      whereArgs: [projectID],
    );
    await _database.delete(
      'DetailProject',
      where: '${DbDetailProjectKeys.detailProjectID} = ?',
      whereArgs: [projectID],
    );
    await _database.delete(
      'Projects',
      where: '${DbProjectsKeys.id} = ?',
      whereArgs: [projectID],
    );
  }

  @override
  Future<List<ProjectDto>> getProjects() async {
    const keyArg = "${DbUsersProfileIDKeys.detailProjectID} = ?";

    List<ProjectDto> projectList = [];

    final List<Map<String, dynamic>> projectsMapList =
        await _database.query("Projects");

    for (var project in projectsMapList) {
      final List<int> list = [];
      final List<Map<String, dynamic>> userInfoMapList = await _database.query(
          "UsersProfileID",
          distinct: true,
          where: keyArg,
          whereArgs: [project[DbProjectsKeys.id]]);
      for (var info in userInfoMapList) {
        list.add(info[DbUsersProfileIDKeys.profileID]);
      }
      projectList.add(ProjectDto.fromMap(project, list));
    }
    return projectList;
  }

  @override
  Future<void> restoreProject(int projectID) async {

    await _database.update(
      'Projects',
      {DbProjectsKeys.archivedAt: null},
      where: '${DbProjectsKeys.id} = ?',
      whereArgs: [projectID],
    );
  }

  @override
  Future<void> updateProject(List<ProjectModel> projects) async {
    final batch = _database.batch();
    batch.delete("Projects");
    batch.delete("UsersProfileID");
    await batch.commit();
    for (var project in projects) {
      batch.insert('Projects', project.toMap());
      for (var user in project.profilesIDs) {
        batch.insert('UsersProfileID', {
          DbUsersProfileIDKeys.profileID: user,
          DbUsersProfileIDKeys.detailProjectID: project.id
        });
      }
    }
    await batch.commit();
  }

  @override
  Future<void> updateDetailProject(DetailProjectDto detailProjects) async {
    final batch = _database.batch();
    batch.delete("DetailProject",
        where: '${DbDetailProjectKeys.detailProjectID} = ?',
        whereArgs: [detailProjects.id]);
    batch.delete("Invites",
        where: '${DbInvitesKeys.detailProjectID} = ?',
        whereArgs: [detailProjects.id]);
    batch.delete("UserEngagements",
        where: '${DbUserEngagementsKeys.detailProjectID} = ?',
        whereArgs: [detailProjects.id]);
    batch.delete("UserInfo",
        where: '${DbUserInfoKeys.detailProjectID} = ?',
        whereArgs: [detailProjects.id]);
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
    await _database.update(
      'Projects',
      {DbProjectsKeys.archivedAt: DateTime.now().toString()},
      where: '${DbProjectsKeys.id} = ?',
      whereArgs: [projectID],
    );
  }
}
