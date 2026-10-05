import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/app_constatns.dart';
import 'package:flutter_application_1/core/widgets/main_button.dart';
import 'package:flutter_application_1/features/home/home_screen.dart';
import 'package:flutter_application_1/features/login/data/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _image;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(source: source);
      if (photo != null) setState(() => _image = File(photo.path));
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;
    final user = UserModel(
      name: _nameController.text.trim(),
      image: _image?.path ?? '',
    );
    await Hive.box<UserModel>(AppConstants.userBoxName)
        .put(AppConstants.currentUser, user);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _showPickerSheet() {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Mainbutton(
              title: 'camera'.tr(),
              ontap: () {
                Navigator.pop(sheetContext);
                _pick(ImageSource.camera);
              },
            ),
            SizedBox(height: 8.h),
            Mainbutton(
              title: 'gallery'.tr(),
              ontap: () {
                Navigator.pop(sheetContext);
                _pick(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: _showPickerSheet,
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: const Color(0xFFE8EBF5),
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(
                              Icons.person,
                              size: 40.r,
                              color: const Color(0xFF3F51B5),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'create_profile'.tr(),
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1C1E26),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'add_name_photo'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'full_name'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1C1E26),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 16.sp),
                    textInputAction: TextInputAction.done,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'name_required'.tr()
                        : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Mainbutton(title: 'continue'.tr(), ontap: _continue),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
