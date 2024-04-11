import 'package:tt_bytepace/src/features/login/data/auth_repository.dart';
import 'package:tt_bytepace/src/features/login/data/data_sources/auth_data_sources.dart';
import 'package:tt_bytepace/src/features/login/models/dto/login_dto.dart';
import 'package:tt_bytepace/src/features/login/models/login_model.dart';

class AuthRepositoryTest implements IAuthRepository {
  final IAuthDataSources _networkAuthDataSources;

  AuthRepositoryTest({required IAuthDataSources networkAuthDataSources})
      : _networkAuthDataSources = networkAuthDataSources;

  @override
  Future<LoginModel> doLogin(String email, String password) async {
    var dto = const LoginDto(id: 0, username: "", email: "", accessToken: "");
    try {
      dto = await _networkAuthDataSources.login(email, password);
    } on Exception {
      print("Ошибка логина");
      throw Exception();
    }
    return LoginModel.fromDto(dto);
  }

  @override
  Future<void> doLogout() async {
    await _networkAuthDataSources.logout();
  }

  @override
  Future<String?> getToken() {
    return _networkAuthDataSources.getToken();
  }
}
