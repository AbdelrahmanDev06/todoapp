import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/login/data/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAppBar extends StatelessWidget {
  final UserModel? user;
  final VoidCallback onAvatarTap;

  const HomeAppBar({super.key, required this.user, required this.onAvatarTap});

  String get _greetingKey {
    final h = DateTime.now().hour;
    if (h < 12) return 'good_morning';
    if (h < 17) return 'good_afternoon';
    return 'good_evening';
  }

  ImageProvider? get _image {
    final path = user?.image ?? '';
    if (path.isEmpty || !File(path).existsSync()) return null;
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    return Row(
      children: [
        GestureDetector(
          onTap: onAvatarTap,
          child: CircleAvatar(
            radius: 28.r,
            backgroundColor: const Color(0xFF3F51B5),
            backgroundImage: image,
            child: image == null
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greetingKey.tr()} 👋',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              Text(
                (user?.name ?? '').trim().isEmpty ? 'Guest' : user!.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Icon(Icons.notifications_none),
      ],
    );
  }
}
