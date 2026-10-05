import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsCard extends StatelessWidget {
  final int total;
  final int done;
  final int pending;

  const StatsCard({
    super.key,
    required this.total,
    required this.done,
    required this.pending,
  });

  Widget item(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFF3F51B5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          item('$total', 'tasks'.tr()),
          item('$done', 'done'.tr()),
          item('$pending', 'pending'.tr()),
        ],
      ),
    );
  }
}
