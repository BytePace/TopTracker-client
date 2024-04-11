import 'package:tt_bytepace/src/features/login/data/data_sources/auth_data_sources.dart';
import 'package:tt_bytepace/src/features/login/models/dto/login_dto.dart';

class NetworkAuthDataSourcesTest implements IAuthDataSources {
  @override
  Future<void> logout() async {}

  @override
  Future<LoginDto> login(String email, String password) async {
    return const LoginDto(id: 0, username: "", email: "", accessToken: "");
  }

  @override
  Future<String?> getToken() async {
    return null;
  }
}
