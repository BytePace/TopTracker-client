import 'package:flutter_test/flutter_test.dart';
import 'package:tt_bytepace/src/features/profile/data/data_sources/profile_data_sources.dart';
import 'package:tt_bytepace/src/features/profile/data/profile_repository.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_info_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/user_model.dart';

import 'profile_network_data_source.dart';

void main() {
  late ProfileRepositoryTest profileRepositoryTest;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    profileRepositoryTest = ProfileRepositoryTest(
      networkProfileDataSources: NetworkProfileDataSourcesTest(),
    );
  });
  group("Profile repository test", () {
    test('get day of monday', () async {
      final now = DateTime.now();
      DateTime monday = profileRepositoryTest.getMondayDate(now);
      expect(monday.day, 8);
    });

    test('get user stat', () async {
      final userInfoDtoExpect = UserInfoModel(profileID: 377593, name: 'Aleksandr Sherbakov', email: '', workedTotal: 36000);
      final userInfoDto = await profileRepositoryTest.getStats([]);

      expect(userInfoDto, userInfoDtoExpect);
    });
  });
}

class ProfileRepositoryTest implements IProfileRepository {
  final INetworkProfileDataSources _networkProfileDataSources;

  ProfileRepositoryTest(
      {required INetworkProfileDataSources networkProfileDataSources})
      : _networkProfileDataSources = networkProfileDataSources;

  @override
  Future<UserInfoModel> getStats(List<ProjectModel> projects) async {
    UserInfoDto dto =
        const UserInfoDto(profileID: 9, name: "", email: "", workedTotal: 0);
    try {
      dto = await _networkProfileDataSources.getStats(projects);
    } catch (e) {
      print(e);
    }
    return UserInfoModel.fromDto(dto);
  }

  DateTime getMondayDate(DateTime date) {
    return _networkProfileDataSources.getMondayDate(date);
  }
}
