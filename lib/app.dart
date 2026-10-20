import 'package:flutter/material.dart';

import 'app_services.dart';
import 'core/app_settings.dart';
import 'core/l10n.dart';
import 'core/theme.dart';
import 'features/home/home_screen.dart';

class BusFareApp extends StatelessWidget {
  const BusFareApp({super.key, required this.services, required this.settings});

  final AppServices services;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => MaterialApp(
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        locale: settings.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: HomeScreen(services: services, settings: settings),
      ),
    );
  }
}
