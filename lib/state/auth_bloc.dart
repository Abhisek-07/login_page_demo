import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:login_page_demo/models/user.dart';

// Authentication Events
abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String userName;
  final String email;
  final String password;

  SignUpEvent(this.userName, this.email, this.password);
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

// Authentication States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

// Authentication Bloc with new 'on<Event>' API
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Box<User> userBox;

  AuthBloc(this.userBox) : super(AuthInitial()) {
    // Handling the SignUpEvent
    on<SignUpEvent>((event, emit) async {
      if (userBox.containsKey(event.email)) {
        emit(AuthFailure('User already exists with this email.'));
      } else {
        final newUser = User(
          userName: event.userName,
          email: event.email,
          password: event.password,
        );
        await userBox.put(event.email, newUser);
        emit(AuthSuccess(newUser));
      }
    });

    // Handling the LoginEvent
    on<LoginEvent>((event, emit) async {
      final user = userBox.get(event.email);
      if (user == null || user.password != event.password) {
        emit(AuthFailure('Invalid email or password.'));
      } else {
        emit(AuthSuccess(user));
      }
    });
  }
}
