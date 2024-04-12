
import 'package:tt_bytepace/src/features/projects/model/dto/invite_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_dto.dart';
import 'package:tt_bytepace/src/features/users/data/data_sources/user_data_source.dart';
import 'package:tt_bytepace/src/features/users/models/dto/all_users_dto.dart';

class NetworkUserDataSourceTest implements IUserDataSource {
  @override
  Future<void> revokeInvite(int invitationID) async {}

  @override
  Future<InvitedDto> addUser(
      String email, String rate, String role, int id) async {
    final response = <String, dynamic>{
      "invitations": [
        {"name": "", "id": 10}
      ]
    };

    return InvitedDto.fromJson(response['invitations'][0]);
  }

  @override
  Future<void> deleteUser(int projectId, int profileId) async {}

  @override
  Future<List<int>> getProjectsID() async {
    final responseIDs = <String, dynamic>{
      "projects": [
        {
          "id": 1,
          "name": "1",
          "archived_at": null,
          "current_user": {
            "role": "1",
            "joined": "1",
          },
          "profiles_ids": [1],
          "admin_profile": {
            "name": "Tatiana Tytar",
          },
          "created_at": "1",
          "engagement_ids": [1],
        }
      ]
    };
    List<int> projectID = [];

    responseIDs['projects'].forEach((project) => {
          if (project['archived_at'] == null) {projectID.add(project['id'])}
        }); //достаю все id всех проектов

    return projectID;
  }

  @override
  Future<List<UserDto>> getAllUsers() async {
    final Map<int, UserDto> allUsers = {};
    allUsers[0] = (UserDto(userID: 0, name: '', email: ''));

    return allUsers.values.toList();
  }

  @override
  Future<List<ProfileIdDto>> getAllProfileID() async {
    final response = <String, dynamic>{
      "filters": {
        "projects": [
          {"id": 1, "label": "1"},
          {"id": 2, "label": "1"}
        ],
        "workers": [
          {"id": 0, "label": ""}
        ]
      }
    };
    final List<ProfileIdDto> idList = [];
    response["filters"]['workers'].forEach((element) {
      idList
          .add(ProfileIdDto(profileID: element['id'], name: element["label"]));
    });
    return idList;
  }
}
