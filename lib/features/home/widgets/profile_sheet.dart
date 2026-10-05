import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/app_constatns.dart';
import 'package:flutter_application_1/features/login/data/user_model.dart';
import 'package:flutter_application_1/features/login/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// تغيير اللغة + تسجيل الخروج (يمسح بيانات المستخدم فقط، المهام تفضل).
void showProfileSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'language'.tr(),
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            children: [
              ChoiceChip(
                label: const Text('English'),
                selected: context.locale.languageCode == 'en',
                onSelected: (_) {
                  Navigator.pop(sheetContext);
                  context.setLocale(const Locale('en'));
                },
              ),
              ChoiceChip(
                label: const Text('العربية'),
                selected: context.locale.languageCode == 'ar',
                onSelected: (_) {
                  Navigator.pop(sheetContext);
                  context.setLocale(const Locale('ar'));
                },
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              icon: const Icon(Icons.logout),
              label: Text('logout'.tr()),
              onPressed: () async {
                Navigator.pop(sheetContext);
                await Hive.box<UserModel>(AppConstants.userBoxName)
                    .delete(AppConstants.currentUser);
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
