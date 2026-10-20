import 'dart:async';

import 'package:flutter/material.dart';

import 'app.dart';
import 'app_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final services = AppServices.fromConfig();
  unawaited(services.fares.init());
  unawaited(services.feedback.syncPending());

  runApp(BusFareApp(services: services));
}
