

//class Users {
//  Map<int, UserModel> users;
//
//  Users({required this.users});
//
//  factory Users.fromJson(Map<String, dynamic> json) {
//    final List<UserModel> users = [];
//    json["workers"].forEach((json) => {users.add(UserModel.fromJson(json))});
//
//    final List<int> profileIDs = [];
//    json["statistics"].forEach((json) => {profileIDs.add(json['profile_id'])});
//    Map<int, UserModel> map = {};
//    for (int i = 0; i < users.length; i++) {
//      map[profileIDs[i]] = users[i];
//    }
//
//    return Users(
//      users: map,
//    );
//  }
//}

class AllUsersList {
  final List<AllUsers> all;

  AllUsersList({required this.all});

   factory AllUsersList.fromJson(Map<String, dynamic> json) {
    final List<AllUsers> users = [];
    json['filters']["workers"].forEach((json) => {users.add(AllUsers.fromJson(json))});

    return AllUsersList(
      all: users,
    );
  }
}

class AllUsers {
  final int profileID;
  final String name;

  AllUsers({required this.profileID, required this.name});

  factory AllUsers.fromJson(Map<String, dynamic> json) {
    return AllUsers(
      profileID: json['id'].toInt(),
      name: json['label'],
    );
  }
}
