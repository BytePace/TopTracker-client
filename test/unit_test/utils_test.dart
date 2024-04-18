import 'package:flutter_test/flutter_test.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/user_model.dart';
import 'package:tt_bytepace/src/features/projects/utils/methods.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/users/utils/methods.dart';

void main() {
  setUp(() {});
  group("utils methods test", () {
    test('get user projects', () async {
      final firstList = [
        ProjectModel(
            id: 0,
            name: 'project without 0',
            adminName: '',
            createdAt: '',
            profilesIDs: [1, 2, 3],
            archivedAt: null,
            currentUser: ''),
        ProjectModel(
            id: 1,
            name: 'project with user 0',
            adminName: '',
            createdAt: '',
            profilesIDs: [0],
            archivedAt: null,
            currentUser: '')
      ];
      final secondList = [ProfileIdModel(profileID: 0, name: '')];
      final projects = getUserProject(firstList, secondList, 0);
      final expectProjects = [
        ProjectModel(
            id: 1,
            name: 'project with user 0',
            adminName: '',
            createdAt: '',
            profilesIDs: [0],
            archivedAt: null,
            currentUser: '')
      ];
      expect(projects, expectProjects);
    });

    test("get list user without already on project", () {
      final userOnProject = <UserEngagementsModel>[
        UserEngagementsModel(userID: 0, profileId: 0, workedTotal: 0),
        UserEngagementsModel(userID: 1, profileId: 1, workedTotal: 0)
      ];
      final allUsersList = <UserModel>[
        UserModel(userID: 0, name: '', email: ''),
        UserModel(userID: 1, name: '', email: ''),
        UserModel(userID: 2, name: '', email: ''),
        UserModel(userID: 3, name: '', email: '')
      ];
      final users = getAllUsersWhithoutOnProject(userOnProject, allUsersList);
      final usersExpect = [
        UserModel(userID: 2, name: '', email: ''),
        UserModel(userID: 3, name: '', email: '')
      ];

      expect(users, usersExpect);
    });
    test("get list user on project", () {
      final userOnProject = <UserEngagementsModel>[
        UserEngagementsModel(userID: 0, profileId: 0, workedTotal: 0),
        UserEngagementsModel(userID: 1, profileId: 1, workedTotal: 0)
      ];
      final allUsersList = <UserModel>[
        UserModel(userID: 0, name: '', email: ''),
        UserModel(userID: 1, name: '', email: ''),
        UserModel(userID: 2, name: '', email: ''),
        UserModel(userID: 3, name: '', email: '')
      ];
      final users = getListUsersOnProject(userOnProject, allUsersList);
      final usersExpect = [
        UserInfoModel(profileID: 0, name: '', email: '', workedTotal: 0),
        UserInfoModel(profileID: 1, name: '', email: '', workedTotal: 0)
      ];

      expect(users, usersExpect);
    });
  });
}
