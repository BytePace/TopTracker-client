
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:tt_bytepace/src/features/login/models/dto/login_dto.dart';
import 'package:tt_bytepace/src/features/login/services/auth_service.dart';

void main() {
  late LoginDto loginModel;

  setUp(() {
    loginModel = const LoginDto(
        username: 'name', email: 'email', id: 1, access_token: 'token');
  });
  group("Login test", () {
    test('login_model from json', () {
      loginModel = LoginDto.fromJson({
        "access_token":
            "SXBRQ1pwa0dsNUo0TGZxQjZld0JGZGU1ejdGYThXVncyRnoyMUJmL3JobEM5WHZQWVpPcTRlMGJlR0VyQ2szOS0tQkdEMCtxdklaNk0yQThBcXBGMFhyQT09--3bc39e766b3d149fe510571dffbddc9fda1a5ab1",
        "user": {
          "id": 347810,
          "email": "aleksandr.sherbakov@bytepace.com",
          "name": "Aleksandr Sherbakov",
          "time_zone": "Asia/Omsk",
          "avatar_url":
              "https://secure.gravatar.com/avatar/cae094daa317e024457419aa9f0e2bab?d=blank",
          "company_name": "Bytepace",
          "invoice_due_period": 14,
          "address": null,
          "phone": null,
          "currency": null,
          "used_desktop": true,
          "has_invoices": false,
          "first_name": "Aleksandr",
          "middle_name": null,
          "last_name": "Sherbakov",
          "city": "Omsk",
          "country_id": 178
        },
        "profiles": [
          {
            "id": 377593,
            "type": "freelancer",
            "name": "Aleksandr Sherbakov",
            "avatar_url":
                "https://secure.gravatar.com/avatar/cae094daa317e024457419aa9f0e2bab?d=blank",
            "company_name": "Bytepace",
            "address": null,
            "phone": null,
            "active": true
          }
        ]
      });
      expect(
          loginModel.email == "aleksandr.sherbakov@bytepace.com" &&
              loginModel.id == 347810 &&
              loginModel.username == "Aleksandr Sherbakov" &&
              loginModel.access_token ==
                  "SXBRQ1pwa0dsNUo0TGZxQjZld0JGZGU1ejdGYThXVncyRnoyMUJmL3JobEM5WHZQWVpPcTRlMGJlR0VyQ2szOS0tQkdEMCtxdklaNk0yQThBcXBGMFhyQT09--3bc39e766b3d149fe510571dffbddc9fda1a5ab1",
          true);
    });

    test("auth_service авторизован ли пользователь", () {
      final AuthService authService = AuthService();
      bool isAuthorized = authService.isAuthorized;
      expect(isAuthorized, false);
      authService.setUser(loginModel);
      isAuthorized = authService.isAuthorized;
      expect(isAuthorized, true);
    });

    test("auth_service установить пользователя", () {
      final AuthService authService = AuthService();
      authService.setUser(loginModel);
      expect(authService.user.username, "name");
    });

    test("auth_service получения токена сохраненного в shared preferences",
        () async {
      SharedPreferences.setMockInitialValues({});
      SharedPreferences pref = await SharedPreferences.getInstance();
      final AuthService authService = AuthService();

      pref.setString("access_token", "token");

      expect(await authService.getToken(), "token");
    });

    test("auth_service удаление токена с shared preferences",
        () async {
      SharedPreferences.setMockInitialValues({}); //set values here
      SharedPreferences pref = await SharedPreferences.getInstance();
      final AuthService authService = AuthService();

      pref.setString("access_token", "token");
      authService.setUser(loginModel);

      await authService.logout();

      expect(authService.user.access_token=="" && pref.getString("access_token")==null, true);
    });
    test("auth_service log in",
        () async {
      SharedPreferences.setMockInitialValues({}); 
      SharedPreferences pref = await SharedPreferences.getInstance();
      final AuthService authService = AuthService();

      await authService.login('aleksandr.sherbakov@bytepace.com', 'aleksandr.sherb');
      final token = pref.getString("access_token");

      expect(token != null, true);
    });
    
  });
}
