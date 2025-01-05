import "dart:convert";

import "package:frontend_task_app/core/constants.dart";
import "package:frontend_task_app/core/services/sp_service.dart";
import "package:frontend_task_app/features/auth/repository/auth_local_repository.dart";
import "package:frontend_task_app/model/user_model.dart";
import "package:http/http.dart" as http;

class AuthRemoteRepository {
  final spService = SpService();
  final authLocalRepository = AuthLocalRepository();

  Future<UserModel> signup(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${Constants.backendUri}/auth/signup',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (res.statusCode != 201) {
        throw json.decode(res.body)['error'];
      }

      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final res = await http.post(
        Uri.parse("${Constants.backendUri}/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {'email': email, 'password': password},
        ),
      );

      if (res.statusCode != 200) {
        throw json.decode(res.body)['error'];
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        return null;
      }
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/tokenIsValid'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        return null;
      }
      final userResponse = await http.get(
        Uri.parse('${Constants.backendUri}/auth'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (userResponse.statusCode != 200) {
        return null;
      }
      return UserModel.fromJson(userResponse.body);
    } catch (e) {
      print('here');
      final user = await authLocalRepository.getUser();
      print('User from cache ${user.toString()}');
      return user;
    }
  }
}
