import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_page_demo/state/auth_bloc.dart';
import 'package:login_page_demo/ui/auth_page.dart';
import 'package:login_page_demo/models/user.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          // Navigate back to the login screen on logout
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AuthScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome, ${user.userName}'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // Trigger logout event
                context.read<AuthBloc>().add(LogoutEvent());
              },
            ),
          ],
        ),
        body: Center(
          child: Text('Hello, ${user.userName}! This is the Home Screen.'),
        ),
      ),
    );
  }
}
