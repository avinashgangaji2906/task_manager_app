import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_task_app/features/auth/cubit/auth_cubit.dart';

class HomeDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const HomeDrawer({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state as AuthLoggedIn;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drawer Header
          DrawerHeader(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular Avatar
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person), // Replace with actual image path
                ),
                const SizedBox(height: 10),
                // User Name
                Text(
                  user.user.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // User Email
                Text(
                  user.user.email,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Logout Tile
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Logout',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
