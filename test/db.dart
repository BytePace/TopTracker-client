import 'package:tt_bytepace/src/database/database.dart';

void main() async {
  final db = await DBProvider.db.database;
  await db.transaction((txn) async {
    int id = await txn.insert('DetailProject', {
      'name': 'Project 1',
      'currentUserRole': 'Admin',
    });
    print('Inserted into DetailProject with ID: $id');
  });

  // Вставка данных в таблицу UserInfo
  await db.transaction((txn) async {
    int id = await txn.insert('UserInfo', {
      'profileID': 1,
      'name': 'John Doe',
      'email': 'john@example.com',
    });
    print('Inserted into UserInfo with ID: $id');
  });

  // Вставка данных в таблицу Invites
  await db.transaction((txn) async {
    int id = await txn.insert('Invites', {
      'inviteID': 123,
      'name': 'Invitation 1',
    });
    print('Inserted into Invites with ID: $id');
  });

  // Вставка данных в таблицу UserEngagements
  await db.transaction((txn) async {
    int id = await txn.insert('UserEngagements', {
      'profileID': 1,
      'workedTotal': 10,
    });
    print('Inserted into UserEngagements with ID: $id');
  });

  // Закрытие соединения с базой данных
  await db.close();
}
