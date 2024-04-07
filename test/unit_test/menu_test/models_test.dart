import 'package:flutter_test/flutter_test.dart';
import 'package:tt_bytepace/src/features/users/models/dto/all_users_dto.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';

void main() {
  group('ProfileID Unit Test', () {
    test('Parsing JSON with valid data', () {
      // Подготовка данных
      final Map<String, dynamic> json = {
        'label': 'John',
        'id': 123,
      };

      // Выполнение парсинга
      final result = ProfileIdDto.fromJson(json);

      // Проверка результата
      expect(result.profileID, equals(123));
      expect(result.name, equals('John'));
    });

    test('Parsing JSON with invalid data', () {
      // Подготовка данных с неправильным типом значения для ключа 'id'
      final Map<String, dynamic> json = {
        'label': 'Alice',
        'id': 'invalid', // Неправильный тип данных
      };

      // Проверка, что при парсинге выбрасывается ошибка
      expect(() => ProfileIdDto.fromJson(json), throwsNoSuchMethodError);
    });
  });

  group('DetailProjectModel Unit Test', () {
    test('Parsing JSON with valid data', () {
      // Подготовка данных
      final Map<String, dynamic> json = {
        'project': {
          'id': 123,
          'name': 'Project Name',
          'current_user': {'role': 'admin'},
        },
        'users': [
          {'id': 1, 'name': 'User 1', 'email': 'user1@example.com'},
          {'id': 2, 'name': 'User 2', 'email': 'user2@example.com'}
        ],
        'invitations': [],
        'engagements': [
          {
            'profile_id': 1,
            'stats': {'worked_total': 10}
          },
          {
            'profile_id': 2,
            'stats': {'worked_total': 20}
          }
        ]
      };

      // Выполнение парсинга
      final result = DetailProjectModel.fromJson(json);

      // Проверка результата
      expect(result.id, equals(123));
      expect(result.name, equals('Project Name'));
      expect(result.currentUserRole, equals('admin'));

      // Проверка пользователей
      expect(result.users.length, equals(2));
      expect(
          result.users[0],
          equals(UserModel(
              profileID: 1, name: 'User 1', email: 'user1@example.com')));
      expect(
          result.users[1],
          equals(UserModel(
              profileID: 2, name: 'User 2', email: 'user2@example.com')));

      // Проверка приглашений
      expect(result.invitations.length, equals(0));

      // Проверка участников
      expect(result.engagements.length, equals(2));
      expect(result.engagements[0],
          equals(UserEngagementsModel(profileId: 1, workedTotal: 10)));
      expect(result.engagements[1],
          equals(UserEngagementsModel(profileId: 2, workedTotal: 20)));
    });
  });

  group('ProjectsModel Unit Test', () {
    test('Parsing JSON with valid data', () {
      // Подготовка данных
      final Map<String, dynamic> json = {
        'projects': [
          {
            'id': 1,
            'name': 'Project 1',
            'admin_profile': {'name': 'Admin 1'},
            'created_at': '2022-03-20',
            'archived_at': null,
            'profiles_ids': [1, 2, 3]
          },
          {
            'id': 2,
            'name': 'Project 2',
            'admin_profile': {'name': 'Admin 2'},
            'created_at': '2022-03-21',
            'archived_at': '2022-03-25',
            'profiles_ids': [4, 5, 6]
          }
        ],
        'users': [
          {'id': 1, 'name': 'User 1', 'email': 'user1@example.com'},
          {'id': 2, 'name': 'User 2', 'email': 'user2@example.com'}
        ]
      };

      // Выполнение парсинга
      final result = ProjectsModel.fromJson(json);

      // Проверка результата
      expect(result.projects.length, equals(2));
      expect(result.allUsers.length, equals(2));
      expect(result.projects[0].id, equals(1));
      expect(result.projects[0].name, equals('Project 1'));
      expect(result.projects[0].adminName, equals('Admin 1'));
      expect(result.projects[0].createdAt, equals('2022-03-20'));
      expect(result.projects[0].archivedAt, isNull);
      expect(result.projects[0].profilesIDs, equals([1, 2, 3]));

      expect(result.projects[1].id, equals(2));
      expect(result.projects[1].name, equals('Project 2'));
      expect(result.projects[1].adminName, equals('Admin 2'));
      expect(result.projects[1].createdAt, equals('2022-03-21'));
      expect(result.projects[1].archivedAt, equals('2022-03-25'));
      expect(result.projects[1].profilesIDs, equals([4, 5, 6]));

      expect(result.allUsers[0].profileID, equals(1));
      expect(result.allUsers[0].name, equals('User 1'));
      expect(result.allUsers[0].email, equals('user1@example.com'));

      expect(result.allUsers[1].profileID, equals(2));
      expect(result.allUsers[1].name, equals('User 2'));
      expect(result.allUsers[1].email, equals('user2@example.com'));
    });
  });
}
