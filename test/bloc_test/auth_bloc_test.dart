import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tt_bytepace/src/features/login/bloc/auth_bloc.dart';
import '../widget_test/auth_repository_test/auth_data_source_test.dart';
import '../widget_test/auth_repository_test/auth_reposutory_test.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("auth bloc", () {
    setUp(() {});

    AuthBloc buildBloc() {
      return AuthBloc(
        authRepository: AuthRepositoryTest(
            networkAuthDataSources: NetworkAuthDataSourcesTest()),
      );
    }

    group("constructor", () {
      test("works properly", () {
        expect(buildBloc, returnsNormally);
      });

      test("has correct initial state", () {
        expect(buildBloc().state,
            equals(const LoginInitialState(loginModel: null)));
      });
    });

    group("InitialEvent", () {
      blocTest<AuthBloc, AuthState>(
        'emits [IsLoginState] when InitialEvent is added.',
        build: () => buildBloc(),
        act: (bloc) => bloc.add(InitialEvent()),
        expect: () => <IsLoginState>[const IsLoginState()],
      );
      blocTest<AuthBloc, AuthState>(
        'emits [SignInState] when LoginEvent is added.',
        build: () => buildBloc(),
        act: (bloc) => bloc.add(LogInEvent(email: '', password: '')),
        expect: () =>
            [const LoginMessageState(message: "success"), SignInState()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [IsLoginState] when LogOutEvent is added.',
        build: () => buildBloc(),
        wait: const Duration(seconds: 1),
        seed: () => SignInState(),
        act: (bloc) => bloc.add(LogOutEvent()),
        expect: () => [const IsLoginState()],
      );
    });
  });
}
