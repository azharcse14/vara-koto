import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../core/l10n.dart';
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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.about)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 32 + bottomInset),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.fareSource, style: context.text.bodyStrong),
                const SizedBox(height: 6),
                Text(l10n.fareSourceBody, style: context.text.body),
                const SizedBox(height: 6),
                Text(l10n.fareNotice, style: context.text.label),
                const Divider(height: 28),
                Text(l10n.busSource, style: context.text.bodyStrong),
                const SizedBox(height: 6),
                Text(l10n.busSourceBody, style: context.text.body),
                const Divider(height: 28),
                if (fares.dataUpdated != null)
                  Text(
                    l10n.dataUpdated(fares.dataUpdated!),
                    style: context.text.label,
                  ),
                Text(
                  mode == DataMode.local ? l10n.dataLocal : l10n.dataRemote,
                  style: context.text.label,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
