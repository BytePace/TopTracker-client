
import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/users/data/data_sources/savable_user_data_source.dart';
import 'package:tt_bytepace/src/features/users/models/dto/all_users_dto.dart';

class DbUserDataSourceMockTest implements ISavableUserDataSource {
  @override
  Future<void> addUser(int inviteID, int projectID, String name) async {}

  @override
  Future<void> deleteUser(int projectId, int profileId) async {

  }

  @override
  Future<List<ProfileIdDto>> getAllProfileID() async {
    return [ProfileIdDto(profileID: 0, name: '')];
  }

  @override
  Future<List<UserDto>> getAllUsers() async {
    return [UserDto(userID: 0, name: "", email: "")];
  }

  @override
  Future<void> revokeInvite(int invitationID) async {}

  @override
  Future<void> updateAllUsers(List<UserDto> allUsers) async {
    // TODO: implement updateAllUsers
    throw UnimplementedError();
  }
}
