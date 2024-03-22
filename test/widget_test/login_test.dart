import 'package:flutter_test/flutter_test.dart';
import 'package:tt_bytepace/src/features/login/models/login_model.dart';

void main() {
  late LoginModel loginModel;
  setUp(() {
    loginModel =
        const LoginModel(username: '', email: '', id: 1, access_token: '');
  });
  
}
