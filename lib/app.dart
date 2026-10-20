import 'package:flutter/material.dart';

import 'app_services.dart';
import 'core/theme.dart';
import 'features/home/home_screen.dart';

class BusFareApp extends StatelessWidget {
  const BusFareApp({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'লোকাল বাস ভাড়া',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: HomeScreen(services: services),
    );
  }
}
