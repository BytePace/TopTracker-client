import 'package:tt_bytepace/src/features/profile/data/data_sources/profile_data_sources.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';

class NetworkProfileDataSourcesTest implements INetworkProfileDataSources {
  @override
  Future<UserInfoDto> getStats(List<ProjectModel> projects) async {
    final response = <String, dynamic>{
      "data": [
        {
          "id": 377593,
          "label": "Aleksandr Sherbakov",
          "dates": [
            {"date": "Apr 08", "seconds": 0, "urlDate": "2024-04-08"}
          ]
        }
      ],
      "total_seconds": 36000,
      "billable_seconds": 0,
      "billable_amount": null
    };
    print(UserInfoDto.fromJson(response));
    return UserInfoDto.fromJson(response);
  }

  @override
  DateTime getMondayDate(DateTime date) {
    DateTime now = date;
    int mondayOffset = now.weekday - DateTime.monday;
    if (mondayOffset < 0) {
      mondayOffset += 7;
    }
    DateTime mondayDate = now.subtract(Duration(days: mondayOffset));

    return mondayDate;
  }
}
