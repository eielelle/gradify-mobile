import 'package:dio/dio.dart';
import 'package:gradify/config/values/api_endpoints.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gradify/models/teacher_account.dart';

part 'auth_notifier_provider.g.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final TeacherAccount? teacherAccount;
  final String errorMsg;
  final bool isError;

  const AuthState(
      {this.isAuthenticated = false,
      this.isLoading = false,
      this.isError = false,
      this.errorMsg = "",
      this.teacherAccount});
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState();

  Future<void> signIn(String email, String password) async {
    Dio dio = Dio();

    Map<String, dynamic> data = {
      "teacher_account": {"email": email, "password": password}
    };

    try {
      // Initiate loading
      state = const AuthState(isLoading: true);

      Response res =
          await dio.post(ApiEndpoints.signin,
              data: data,
              options: Options(headers: {
                'Content-Type': 'application/json',
              }));

      // Handle the response
      if (res.statusCode == 200) {
        state = AuthState(isAuthenticated: true, teacherAccount: TeacherAccount.fromJson(res.data['data']));
      } else {
        state = const AuthState();
      }
    } catch (e) {
      if (e is DioException) {
        state = AuthState(isError: true, errorMsg: e.response?.data['status']['message']);
      } else {
        state = const AuthState(isError: true, errorMsg: "Something went wrong.");
      }
    }
  }

  void _saveToken() {}
}
