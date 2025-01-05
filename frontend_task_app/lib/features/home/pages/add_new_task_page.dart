import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend_task_app/features/auth/cubit/auth_cubit.dart';
import 'package:frontend_task_app/features/home/cubit/tasks_cubit.dart';
import 'package:frontend_task_app/features/home/pages/home_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewTaskPage extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
        builder: (context) => const AddNewTaskPage(),
      );
  const AddNewTaskPage({super.key});

  @override
  State<AddNewTaskPage> createState() => _AddNewTaskPageState();
}

class _AddNewTaskPageState extends State<AddNewTaskPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Color selectedColor = const Color.fromARGB(255, 207, 165, 101);
  final formKey = GlobalKey<FormState>();

  void createTask() async {
    if (formKey.currentState!.validate()) {
      final user = context.read<AuthCubit>().state as AuthLoggedIn;
      await context.read<TasksCubit>().createTask(
          uid: user.user.id,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          hexColor: selectedColor,
          token: user.user.token,
          dueAt: selectedDate);
    }
  }

  void showSnackbar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add New Task'),
        actions: [
          GestureDetector(
            onTap: () async {
              DateTime? _selectedDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 90),
                ),
              );
              if (_selectedDate != null) {
                setState(() {
                  selectedDate = _selectedDate;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(DateFormat('MM-d-y').format(selectedDate)),
            ),
          )
        ],
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is TasksError) {
            showSnackbar(state.error);
          } else if (state is AddNewTaskSuccess) {
            showSnackbar("Task added !!");
            Navigator.pushAndRemoveUntil(
                context, HomePage.route(), (_) => false);
          }
        },
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(hintText: 'Add New Task'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Title can not be Empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration:
                        const InputDecoration(hintText: 'Add Task Description'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Description can not be Empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ColorPicker(
                    heading: const Text('Select Color'),
                    subheading: const Text('Select a shade'),
                    pickersEnabled: const {ColorPickerType.wheel: true},
                    color: selectedColor,
                    onColorChanged: (color) {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: createTask,
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18),
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
