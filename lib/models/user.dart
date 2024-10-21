import 'package:hive/hive.dart';

part 'user.g.dart'; // Required for generating the adapter

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String userName;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  User({
    required this.userName,
    required this.email,
    required this.password,
  });
}
