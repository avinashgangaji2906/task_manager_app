import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_task_app/core/theme.dart';
import 'package:frontend_task_app/features/auth/cubit/auth_cubit.dart';
import 'package:frontend_task_app/features/auth/pages/signup_page.dart';
import 'package:frontend_task_app/features/home/cubit/tasks_cubit.dart';
import 'package:frontend_task_app/features/home/pages/home_page.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AuthCubit()),
      BlocProvider(create: (_) => TasksCubit()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthCubit>().getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoggedIn) {
            return const HomePage();
          }
          return const SignupPage();
        },
      ),
    );
  }
}
