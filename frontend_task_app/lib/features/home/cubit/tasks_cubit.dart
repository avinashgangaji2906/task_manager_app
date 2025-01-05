import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_task_app/core/utils.dart';
import 'package:frontend_task_app/features/home/repository/task_local_repository.dart';
import 'package:frontend_task_app/features/home/repository/task_remote_repository.dart';
import 'package:frontend_task_app/model/task_model.dart';
part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  final taskRemoteRepository = TaskRemoteRepository();
  final taskLocalRepository = TaskLocalRepository();

  Future<void> createTask({
    required String uid,
    required String title,
    required String description,
    required Color hexColor,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      TasksLoading();

      final taskModel = await taskRemoteRepository.createTask(
          uid: uid,
          title: title,
          description: description,
          hexColor: rgbToHex(hexColor),
          token: token,
          dueAt: dueAt);

      emit(AddNewTaskSuccess(taskModel));
      await taskLocalRepository.insertTask(taskModel);
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> getAllTasks({
    required String token,
  }) async {
    try {
      TasksLoading();

      List<TaskModel> listOfTasks = await taskRemoteRepository.getAllTasks(
        token: token,
      );

      emit(GetTaskSuccess(listOfTasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> syncTasks(String token) async {
    //get all unsynced tasks

    try {
      List<TaskModel> unSyncedTasks =
          await taskLocalRepository.getUnSyncedTasks();
      if (unSyncedTasks.isEmpty) {
        return;
      }
      // store in server/postgres
      final isSynced = await taskRemoteRepository.syncTasks(
          tasks: unSyncedTasks, token: token);
      // change the isSynced parameter 0 to 1
      if (isSynced) {
        print('sync done');
        for (final task in unSyncedTasks) {
          await taskLocalRepository.updateIsSyncedRowValue(task.id, 1);
        }
      }
    } catch (e) {
      return;
    }
  }
}
