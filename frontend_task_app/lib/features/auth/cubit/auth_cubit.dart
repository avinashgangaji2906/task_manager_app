import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_task_app/core/services/sp_service.dart';
import 'package:frontend_task_app/features/auth/repository/auth_local_repository.dart';
import 'package:frontend_task_app/features/auth/repository/auth_remote_repository.dart';
import 'package:frontend_task_app/model/user_model.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final remoteAuthRepository = AuthRemoteRepository();
  final authLocalRepository = AuthLocalRepository();
  final spService = SpService();

  void getUserData() async {
    try {
      emit(AuthLoading());

      final userModel = await remoteAuthRepository.getUserData();
      if (userModel != null) {
        await authLocalRepository.insertUser(userModel);
        emit(AuthLoggedIn(userModel));
        return;
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  void signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      await remoteAuthRepository.signup(
          name: name, email: email, password: password);

      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final userModel =
          await remoteAuthRepository.login(email: email, password: password);

      if (userModel.token.isNotEmpty) {
        spService.setToken(userModel.token);
      }

      await authLocalRepository.insertUser(userModel);

      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
