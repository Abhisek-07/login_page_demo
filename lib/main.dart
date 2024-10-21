import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:login_page_demo/app.dart';
import 'package:login_page_demo/models/user.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory? dir = await getExternalStorageDirectory();
  Hive.init(dir?.path);
  Hive.registerAdapter(UserAdapter());
  final userBox = await Hive.openBox<User>('userBox');
  runApp(App(userBox: userBox));
}
