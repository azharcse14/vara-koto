import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/app_config.dart';
import '../../core/bangla_text.dart';
import '../../core/theme.dart';
import '../../data/fare_repository.dart';
import '../../widgets/common.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, required this.fares, required this.mode});

  final FareRepository fares;
  final DataMode mode;

  static const _links = [
    (label: 'Facebook', url: 'https://www.facebook.com/abrarjahinzihan/', icon: Icons.facebook),
    (label: 'Instagram', url: 'https://www.instagram.com/abrarjahinzihan/', icon: Icons.photo_camera_outlined),
    (label: 'LinkedIn', url: 'https://www.linkedin.com/in/abrar-jahin-zihan-b8b250328', icon: Icons.work_outline),
    (label: 'GitHub', url: 'https://github.com/abrarjahinzihan', icon: Icons.code),
    (label: 'X (Twitter)', url: 'https://x.com/ZihanJahinabrar', icon: Icons.alternate_email),
    (label: 'Lichess', url: 'https://lichess.org/@/AbrarJahinZihan', icon: Icons.grid_view),
    (label: 'Email', url: 'mailto:abrarjahinkhanzihan@gmail.com', icon: Icons.mail_outline),
  ];

  Future<void> _open(BuildContext context, String url) async {
    var opened = false;
    try {
      opened = await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('লিংকটি খোলা যায়নি।')),
      );
    }
  }

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
          const SizedBox(height: 24),
          const SectionHeader(
            title: 'তৈরি করেছেন / Created by',
            subtitle: 'ABRAR JAHIN ZIHAN',
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < _links.length; i++) ...[
                  if (i > 0) const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(_links[i].icon, color: AppColors.textSecondary),
                    title: Text(_links[i].label, style: AppText.body),
                    trailing: const Icon(Icons.open_in_new,
                        size: 18, color: AppColors.textMuted),
                    onTap: () => _open(context, _links[i].url),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
