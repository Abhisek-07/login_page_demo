import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:login_page_demo/models/user.dart';
import 'package:email_validator/email_validator.dart';

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

class LogoutEvent extends AuthEvent {} // New Logout Event

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

// Authentication Bloc with updated validation and logout
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Box<User> userBox;

  AuthBloc(this.userBox) : super(AuthInitial()) {
    // Handling the SignUpEvent
    on<SignUpEvent>((event, emit) async {
      if (!EmailValidator.validate(event.email)) {
        emit(AuthFailure('Please enter a valid email address.'));
        return;
      }

      if (event.password.length < 6) {
        emit(AuthFailure('Password must be at least 6 characters long.'));
        return;
      }

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
      if (!EmailValidator.validate(event.email)) {
        emit(AuthFailure('Please enter a valid email address.'));
        return;
      }

      final user = userBox.get(event.email);
      if (user == null) {
        emit(AuthFailure('No user found with this email.'));
      } else if (user.password != event.password) {
        emit(AuthFailure('Incorrect password.'));
      } else {
        emit(AuthSuccess(user));
      }
    });

    // Handling LogoutEvent
    on<LogoutEvent>((event, emit) async {
      emit(AuthInitial());
    });
  }
}
