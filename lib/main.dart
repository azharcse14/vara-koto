import 'dart:async';

import 'package:flutter/material.dart';

import 'app.dart';
import 'app_services.dart';
import 'core/app_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final services = AppServices.fromConfig();
  unawaited(services.fares.init());
  unawaited(services.feedback.syncPending());
  final settings = await AppSettings.load();

  runApp(BusFareApp(services: services, settings: settings));
}
