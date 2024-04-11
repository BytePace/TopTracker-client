import 'package:tt_bytepace/src/features/projects/data/data_sources/savable_project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';

class DbProjectDataSourceMockTest implements ISavableProjectDataSource {
  @override
  Future<void> archiveProject(int projectID) async {}

  @override
  Future<void> deleteProject(int projectID) async {
    // TODO: implement deleteProject
    throw UnimplementedError();
  }

  @override
  Future<void> dropDB() async {
    // TODO: implement dropDB
    throw UnimplementedError();
  }

  @override
  Future<DetailProjectDto> getDetailProject(int id) async {
    return DetailProjectDto(
        users: [],
        invitations: [],
        id: id,
        name: '',
        engagements: [],
        currentUserRole: "admin");
  }

  @override
  Future<List<ProjectDto>> getProjects() async {
    return [
      ProjectDto(
          id: 1,
          name: "1",
          adminName: "",
          createdAt: "2018-04-06T12:56:24+06:00",
          profilesIDs: [0],
          archivedAt: null,
          currentUser: 'admin'),
      ProjectDto(
          id: 1,
          name: "2",
          adminName: "",
          createdAt: "2018-04-06T12:56:24+06:00",
          profilesIDs: [],
          archivedAt: null,
          currentUser: 'admin'),
      ProjectDto(
          id: 1,
          name: "3",
          adminName: "",
          createdAt: "2018-04-06T12:56:24+06:00",
          profilesIDs: [],
          archivedAt: "2018-04-06T12:56:24+06:00",
          currentUser: 'admin')
    ];
  }

  @override
  Future<void> restoreProject(int projectID) async {}

  @override
  Future<void> updateDetailProject(DetailProjectDto detailProjects) async {}

  @override
  Future<void> updateProject(List<ProjectModel> projects) async {}
}
