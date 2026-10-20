import 'package:flutter/material.dart';

import '../../core/app_settings.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';

void showSettingsSheet(BuildContext context, AppSettings settings) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => _SettingsSheet(settings: settings),
  );
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.settings, style: AppText.title),
            const SizedBox(height: 20),
            Text(l10n.language, style: AppText.label),
            const SizedBox(height: 8),
            // '' stands for "follow the phone"; SegmentedButton can't hold null.
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: '', label: Text(l10n.systemDefault)),
                // Each language is named in itself so anyone can find theirs.
                const ButtonSegment(value: 'bn', label: Text('বাংলা')),
                const ButtonSegment(value: 'en', label: Text('English')),
              ],
              selected: {settings.locale?.languageCode ?? ''},
              showSelectedIcon: false,
              onSelectionChanged: (picked) => settings.setLocale(
                  picked.first.isEmpty ? null : Locale(picked.first)),
            ),
          ],
        ),
      ),
    );
  }
}
