import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/user_model.dart';

List<UserModel> getAllUsersWhithoutOnProject(
    List<UserEngagementsModel> engagements, List<UserModel> allUsers) {
  List<UserModel> list = List.from(allUsers);
  for (var usr in allUsers) {
    for (var user in engagements) {
      if (usr.userID == user.profileId) {
        list.remove(usr);
        break;
      }
    }
  }
  return list;
}

List<UserInfoModel> getListUsersOnProject(
    List<UserEngagementsModel> engagements, List<UserModel> allUsers) {
  final List<UserInfoModel> usersOnProject = [];
  for (var userEngagement in engagements) {
    for (var user in allUsers) {
      if (user.userID == userEngagement.userID) {
        usersOnProject.add(UserInfoModel(
            email: user.email,
            name: user.name,
            profileID: userEngagement.profileId,
            workedTotal: userEngagement.workedTotal));
      }
    }
  }
  return usersOnProject;
}

bool isFutureTime(String currentTime, DateTime currentDate) {
  List<String> parts = currentTime.split(":");
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  final DateTime now = DateTime.now();
  DateTime specifiedTime =
      DateTime(currentDate.year, currentDate.month, currentDate.day, hours, minutes);

  return specifiedTime.isAfter(now);
}

final List<String> listTime = <String>[
  '00:30',
  '01:00',
  '01:30',
  '02:00',
  '02:30',
  '03:00',
  '03:30',
  '04:00',
  '04:30',
  '05:00',
  '05:30',
  '06:00',
  '06:30',
  '07:00',
  '07:30',
  '08:00',
  '08:30',
  '09:00',
  '09:30',
  '10:00',
  '11:30',
  '12:00',
  '13:30',
  '14:00',
  '14:30',
  '15:00',
  '15:30',
  '16:00',
  '16:30',
  '17:00',
  '17:30',
  '18:00',
  '18:30',
  '19:00',
  '19:30',
  '20:00',
  '20:30',
  '21:00',
  '22:30',
  '23:00',
  '23:30'
];

void setTextController(
    String value,
    Duration durationTime,
    TextEditingController toTextEditingController,
    TextEditingController fromTextEditingController) {
  List<String> parts = value.split(":");
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  durationTime = Duration(hours: hours, minutes: minutes);

  toTextEditingController.text = DateFormat.Hm().format(DateTime.now());

  final resultDateTime = DateTime.now().subtract(durationTime);
  String formattedResultTime =
      '${resultDateTime.hour.toString().padLeft(2, '0')}:${resultDateTime.minute.toString().padLeft(2, '0')}';
  fromTextEditingController.text = formattedResultTime;
}

Map<String, RegExp>? filter = {
  "#": RegExp(r'[0-2]'),
  "&": RegExp(r'[0-9]'),
  "*": RegExp(r'[0-5]'),
  "^": RegExp(r'[0-9]')
};
