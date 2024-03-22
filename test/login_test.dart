import 'package:test/test.dart';
import 'package:tt_bytepace/src/features/login/models/login_model.dart';

void main() {
  test('rest login model from json', () {
    LoginModel loginModel =
        const LoginModel(username: '', email: '', id: 1, access_token: '');

    loginModel = LoginModel.fromJson({
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
}
