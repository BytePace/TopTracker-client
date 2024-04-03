import 'package:tt_bytepace/src/features/projects/model/dto/project_dto.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../model/dto/detail_project_dto.dart';

abstract interface class ISavableProjectDataSource {
  Future<List<DetailProjectDto>> getDetailProjects();
}

class DbProjectDataSource implements ISavableProjectDataSource {
  final Database _database;
  const DbProjectDataSource({required Database database})
      : _database = database;

  @override
  Future<List<DetailProjectDto>> getDetailProjects() async {
    const keyArg = "detail_project_id = ?";
    const String queryDetailProject =
        '''SELECT DetailProject.*, UserInfo.*, Invites.*, UserEngagements.*
          FROM detail_user_info_engagemets
          JOIN UserInfo ON detail_user_info_engagemets.user_info_profile_id = UserInfo.profile_id
          JOIN Invites ON detail_user_info_engagemets.invite_id = Invites.invite_id
          JOIN DetailProject ON detail_user_info_engagemets.detail_project_id = DetailProject.datail_project_id
          JOIN UserEngagements ON detail_user_info_engagemets.user_engagements_id = UserEngagements.user_engagaments_id''';

    final List<DetailProjectDto> detailProjectsList = [];

    final List<UserEngagementsDto> userEngagementsDto = [];
    final List<InvitedDto> invitations = [];
    final List<UserInfoDto> userInfo = [];

    final List<Map<String, dynamic>> detailProjectsMapList =
        await _database.query(queryDetailProject);
    detailProjectsMapList.forEach((project) async {

      final List<Map<String, dynamic>> detailInfo =
          await _database.query(queryDetailProject,
              where: keyArg, whereArgs: [project["detail_project_id"]]);

      detailInfo.forEach((info) {
        invitations.add(InvitedDto.from);
        userEngagementsDto.add(UserEngagementsDto.from);
        userInfo.add(UserInfoDto.from);
      });
      detailProjectsList.add(DetailProjectDto.from);
    });
    return detailProjectsList;
  }
}
