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

List<String> generateTimeList() {
  final List<String> listTime = [];
  for (int hour = 0; hour < 24; hour++) {
    for (int minute = 0; minute < 60; minute += 30) {
      // Форматирование времени в строку 'HH:mm'
      final formattedTime = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      listTime.add(formattedTime);
    }
  }
  return listTime;
}

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

// Функция для проверки валидности email
bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}
