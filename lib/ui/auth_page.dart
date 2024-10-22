import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_page_demo/state/auth_bloc.dart';
import 'package:login_page_demo/ui/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  bool isSignUp = false;

  String? _validateEmail(String? value) {
    if (value == null ||
        !RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateUserName(String? value) {
    if (isSignUp && (value == null || value.isEmpty)) {
      return 'Please enter your user name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
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
        appBar: AppBar(
          title: Text(isSignUp ? 'Sign Up' : 'Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (isSignUp)
                  TextFormField(
                    controller: _userNameController,
                    decoration: const InputDecoration(labelText: 'User Name'),
                    validator: _validateUserName,
                  ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: _validateEmail,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (isSignUp) {
                        context.read<AuthBloc>().add(
                              SignUpEvent(
                                _userNameController.text,
                                _emailController.text,
                                _passwordController.text,
                              ),
                            );
                      } else {
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
                TextButton(
                  onPressed: () {
                    setState(() {
                      isSignUp = !isSignUp;
                    });
                  },
                  child: Text(isSignUp
                      ? 'Already have an account? Login'
                      : 'New user? Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
