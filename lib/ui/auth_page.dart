import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_page_demo/state/auth_bloc.dart';
import 'package:login_page_demo/ui/home_screen.dart';

class AuthScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  bool isSignUp = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Navigate to home page on successful login/signup
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(user: state.user)),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              // Add form fields for email, password, and user name (for signup)
              // Add a button for login/signup
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (isSignUp) {
                      // Trigger SignUp Event
                      context.read<AuthBloc>().add(
                            SignUpEvent(
                              _userNameController.text,
                              _emailController.text,
                              _passwordController.text,
                            ),
                          );
                    } else {
                      // Trigger Login Event
                      context.read<AuthBloc>().add(
                            LoginEvent(
                              _emailController.text,
                              _passwordController.text,
                            ),
                          );
                    }
                  }
                },
                child: Text(isSignUp ? 'Sign Up' : 'Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
