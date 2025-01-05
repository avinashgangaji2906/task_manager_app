import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_task_app/core/utils.dart';
import 'package:frontend_task_app/features/auth/cubit/auth_cubit.dart';
import 'package:frontend_task_app/features/home/cubit/tasks_cubit.dart';
import 'package:frontend_task_app/features/home/pages/add_new_task_page.dart';
import 'package:frontend_task_app/features/home/widgets/date_selector.dart';
import 'package:frontend_task_app/features/home/widgets/home_drawer.dart';
import 'package:frontend_task_app/features/home/widgets/task_cards.dart';
import 'package:frontend_task_app/model/task_model.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    getAllTasks();
    super.initState();
  }

  void getAllTasks() async {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    await context.read<TasksCubit>().getAllTasks(
          token: user.user.token,
        );

    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        if (!mounted) return;
        await context.read<TasksCubit>().syncTasks(user.user.token);
      }
    });
  }

  void logout() async {
    context.read<AuthCubit>().logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewTaskPage.route());
            },
            icon: const Icon(CupertinoIcons.add),
          ),
        ],
      ),
      drawer: HomeDrawer(
        onLogout: logout,
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TasksError) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is GetTaskSuccess) {
            final tasks = state.listOfTasks
                .where((element) =>
                    DateFormat('d').format(element.dueAt) ==
                        DateFormat('d').format(selectedDate) &&
                    selectedDate.month == element.dueAt.month &&
                    selectedDate.year == element.dueAt.year)
                .toList();
            return Column(
              children: [
                // custom date picker
                DateSelector(
                  selectedDate: selectedDate,
                  onTap: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                // list of cards

                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      TaskModel task = tasks[index];
                      return TaskCards(
                          color: hexToRgb(task.hexColor),
                          titleText: task.title,
                          dueAt: task.dueAt,
                          descriptionText: task.description);
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
