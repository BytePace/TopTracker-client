import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'project_list_event.dart';
part 'project_list_state.dart';

class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  ProjectListBloc() : super(ProjectListInitial()) {
    on<ProjectListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
