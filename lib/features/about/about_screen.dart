import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../core/bangla_text.dart';
import '../../core/theme.dart';
import '../../data/fare_repository.dart';
import '../../widgets/common.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, required this.fares, required this.mode});

  final FareRepository fares;
  final DataMode mode;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(title: const Text('তথ্য / About')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 32 + bottomInset),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ভাড়ার তথ্যসূত্র', style: AppText.bodyStrong),
                const SizedBox(height: 6),
                const Text(
                  'বিআরটিএ ডিজেল চালিত বাস ভাড়া চার্ট। সর্বনিম্ন ভাড়া ১০.০০ টাকা।',
                  style: AppText.body,
                ),
                const SizedBox(height: 6),
                const Text(
                  '০৭ আশ্বিন ১৪৩৩ বঙ্গাব্দ / ২২ সেপ্টেম্বর ২০২৬\n'
                  'প্রজ্ঞাপন নং-৩৫.০০.০০০০.০২০.২৬.০০৫.১৬-৫৪০',
                  style: AppText.label,
                ),
                const Divider(height: 28),
                Text(
                  'ডেটা সংস্করণ: ${toBnDigits(fares.dataVersion)}',
                  style: AppText.label,
                ),
                Text(
                  mode == DataMode.local
                      ? 'সব তথ্য অ্যাপের ভেতরেই আছে, ইন্টারনেট ছাড়াও চলে।'
                      : 'তথ্য সার্ভার থেকে হালনাগাদ হয়, ইন্টারনেট না থাকলে শেষ সংরক্ষিত তথ্য দেখায়।',
                  style: AppText.label,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
