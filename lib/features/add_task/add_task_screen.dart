import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/task_model.dart';
import 'task_constants.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;
  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _subtitle;
  late String _status;
  late int _colorValue;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _title = TextEditingController(text: t?.title ?? '');
    _subtitle = TextEditingController(text: t?.subtitle ?? '');
    _status = t?.status ?? taskStatuses.first;
    _colorValue = t?.colorValue ?? taskColors.first.toARGB32();
  }

  @override
  void dispose() {
    _title.dispose();
    _subtitle.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final t = widget.task;
    if (t == null) {
      Hive.box<TaskModel>('tasks').add(
        TaskModel(
          title: _title.text.trim(),
          subtitle: _subtitle.text.trim(),
          status: _status,
          colorValue: _colorValue,
        ),
      );
    } else {
      t.title = _title.text.trim();
      t.subtitle = _subtitle.text.trim();
      t.status = _status;
      t.colorValue = _colorValue;
      t.save();
    }
    Navigator.pop(context);
  }

  InputDecoration _decoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      );

  Widget _label(String key) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(
          key.tr(),
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(isEdit ? 'edit_task'.tr() : 'add_task'.tr()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('task_title'),
                TextFormField(
                  controller: _title,
                  decoration: _decoration('task_title_hint'.tr()),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'title_required'.tr()
                      : null,
                ),
                SizedBox(height: 20.h),
                _label('description'),
                TextFormField(
                  controller: _subtitle,
                  maxLines: 6,
                  decoration: _decoration('description_hint'.tr()),
                ),
                SizedBox(height: 20.h),
                _label('status'),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: _decoration(''),
                  borderRadius: BorderRadius.circular(16),
                  items: taskStatuses
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(statusKey(s).tr()),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _status = v ?? _status),
                ),
                SizedBox(height: 20.h),
                _label('choose_color'),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: taskColors.map((c) {
                    final selected = _colorValue == c.toARGB32();
                    return GestureDetector(
                      onTap: () => setState(() => _colorValue = c.toARGB32()),
                      child: Container(
                        width: 40.r,
                        height: 40.r,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF1C1E26)
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: selected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 20)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF525A93),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: _save,
                    child: Text(
                      'save_task'.tr(),
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
