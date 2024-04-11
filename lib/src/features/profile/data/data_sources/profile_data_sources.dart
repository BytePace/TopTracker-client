import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';

abstract interface class INetworkProfileDataSources {
  Future<UserInfoDto> getStats(List<ProjectModel> projects);
  DateTime getMondayDate(DateTime date);
}

class NetworkProfileDataSources implements INetworkProfileDataSources {
  final Dio _dio;

  const NetworkProfileDataSources({required Dio dio}) : _dio = dio;

  @override
  Future<UserInfoDto> getStats(List<ProjectModel> projects) async {
    final prefs = await SharedPreferences.getInstance();
    final access_token = prefs.getString("access_token");
    final current_user_id = prefs.getInt("current_user_id");
    String queryProjects = "";
    for (var project in projects) {
      if (project.archivedAt == null) {
        queryProjects += "project_ids[]=${project.id}&";
      }
    }
    final mondayDate =
        DateFormat('yyyy-MM-dd').format(getMondayDate(DateTime.now()));
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      final response = await _dio.get(
          '/reports/chart?${queryProjects}worker_ids[]=$current_user_id&start_date=$mondayDate&end_date=$currentDate&access_token=$access_token');

      if (response.statusCode == 200) {
        return UserInfoDto.fromJson(response.data['reports']['workers']);
      } else {
        print(response.statusCode);
        print(response.data);
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to login $e');
    }
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
