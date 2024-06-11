import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';

class ProjectInfoScreenArgument {
  final String role;
  final int id;
  final String name;
  final List<UserModel> allUsers;

  ProjectInfoScreenArgument(
      {required this.role,
      required this.id,
      required this.name,
      required this.allUsers});
}
