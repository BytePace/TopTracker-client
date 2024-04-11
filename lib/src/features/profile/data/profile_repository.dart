import 'package:tt_bytepace/src/features/profile/data/data_sources/profile_data_sources.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/user_model.dart';

abstract interface class IProfileRepository {
  Future<UserInfoModel> getStats(List<ProjectModel> projects);
}

class ProfileRepository implements IProfileRepository {
  final INetworkProfileDataSources _networkAuthDataSources;

  ProfileRepository(
      {required INetworkProfileDataSources networkProfileDataSources})
      : _networkAuthDataSources = networkProfileDataSources;

  @override
  Future<UserInfoModel> getStats(List<ProjectModel> projects) async {
    UserInfoDto dto =
        UserInfoDto(profileID: 9, name: "", email: "", workedTotal: 0);
    try {
      dto = await _networkAuthDataSources.getStats(projects);
    } catch (e) {
      print(e);
    }
    print(dto);
    return UserInfoModel.fromDto(dto);
  }
}
