import 'dart:convert';

import 'package:frontend_task_app/core/constants.dart';
import 'package:frontend_task_app/core/services/sp_service.dart';
import 'package:frontend_task_app/features/home/repository/task_local_repository.dart';
import 'package:frontend_task_app/model/task_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class TaskRemoteRepository {
  final spService = SpService();
  final tasksLocalRepository = TaskLocalRepository();

  Future<TaskModel> createTask(
      {required String title,
      required String uid,
      required String description,
      required String hexColor,
      required DateTime dueAt,
      required String token}) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/tasks'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(
          {
            "title": title,
            "description": description,
            "hexColor": hexColor,
            "dueAt": dueAt.toIso8601String()
          },
        ),
      );

      if (res.statusCode != 201) {
        throw json.decode(res.body)['error'];
      }

      return TaskModel.fromJson(res.body);
    } catch (e) {
      // adding tasks locally when there is no internet connection with server
      try {
        TaskModel task = TaskModel(
            id: const Uuid().v4(),
            uid: uid,
            title: title,
            description: description,
            hexColor: hexColor,
            dueAt: dueAt,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isSynced: 0);
        await tasksLocalRepository.insertTask(task);
        return task;
      } catch (e) {
        rethrow;
      }
    }
  }

  // sync list of tasks to server
  Future<bool> syncTasks(
      {required List<TaskModel> tasks, required String token}) async {
    try {
      // sending a single task as map to server because jsonEncode coverts list of tasks as string
      final listOfTasksToMap = [];
      for (final elemnt in tasks) {
        listOfTasksToMap.add(elemnt.toMap());
      }
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/tasks/sync'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(listOfTasksToMap),
      );

      if (res.statusCode != 201) {
        throw json.decode(res.body)['error'];
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<TaskModel>> getAllTasks({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${Constants.backendUri}/tasks'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (res.statusCode != 200) {
        throw json.decode(res.body)['error'];
      }

      final listOfTasks = jsonDecode(res.body);

      List<TaskModel> allTasks = [];

      for (var elmts in listOfTasks) {
        allTasks.add(TaskModel.fromMap(elmts));
      }

      // add the latest tasks to cache/ local db
      await tasksLocalRepository.insertTasks(allTasks);

      return allTasks;
    } catch (e) {
      // if any error occurs while fetching tasks from server then show them cached tasks
      final tasks = await tasksLocalRepository.getAllTasks();
      if (tasks.isNotEmpty) {
        return tasks;
      }

      rethrow;
    }
  }
}
