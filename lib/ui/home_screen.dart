import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_page_demo/models/user.dart';
import 'package:login_page_demo/state/auth_bloc.dart';
import 'package:login_page_demo/ui/auth_page.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${user.userName}"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Trigger Logout Event
              context.read<AuthBloc>().add(LogoutEvent());
              // Navigate back to the login page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Welcome to the Home Page!"),
      ),
    );
  }
}
