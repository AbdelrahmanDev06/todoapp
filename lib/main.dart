import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/app_constatns.dart';
import 'package:flutter_application_1/features/add_task/data/task_model.dart';
import 'package:flutter_application_1/features/login/data/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'todo_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<UserModel>(AppConstants.userBoxName);
  await Hive.openBox<TaskModel>('tasks');

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const TodoApp(),
    ),
  );
}
