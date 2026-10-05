import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/app_constatns.dart';
import 'package:flutter_application_1/features/login/data/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../add_task/add_task_screen.dart';
import '../add_task/data/task_model.dart';
import 'widgets/home_appbar.dart';
import 'widgets/profile_sheet.dart';
import 'widgets/stats_card.dart';
import 'widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openTask(BuildContext context, {TaskModel? task}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddTaskScreen(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Hive.box<UserModel>(AppConstants.userBoxName)
        .get(AppConstants.currentUser);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFDDE0F7),
        onPressed: () => _openTask(context),
        icon: const Icon(Icons.add, color: Color(0xFF1C1E26)),
        label: Text(
          'task'.tr(),
          style: const TextStyle(color: Color(0xFF1C1E26)),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ValueListenableBuilder(
            valueListenable: Hive.box<TaskModel>('tasks').listenable(),
            builder: (context, Box<TaskModel> box, _) {
              final tasks = box.values.toList();
              final done = tasks.where((t) => t.status == 'Done').length;
              final pending = tasks.length - done;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  HomeAppBar(
                    user: user,
                    onAvatarTap: () => showProfileSheet(context),
                  ),
                  SizedBox(height: 20.h),
                  StatsCard(total: tasks.length, done: done, pending: pending),
                  SizedBox(height: 24.h),
                  Text(
                    'todays_tasks'.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: tasks.isEmpty
                        ? Center(child: Text('no_tasks'.tr()))
                        : ListView.builder(
                            padding: EdgeInsets.only(bottom: 90.h),
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return TaskCard(
                                task: task,
                                onTap: () => _openTask(context, task: task),
                                onDelete: () => task.delete(),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
