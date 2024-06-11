import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tt_bytepace/src/features/profile/data/data_sources/profile_data_sources.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_info_dto.dart';
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
        const UserInfoDto(profileID: 9, name: "", email: "", workedTotal: 0);
    try {
      dto = await _networkAuthDataSources.getStats(projects);
    } catch (e) {
      GetIt.I<Talker>().error(e);
    }
    return UserInfoModel.fromDto(dto);
  }
}
