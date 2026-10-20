// Lays out the route screen at phone width in both languages; Flutter fails the
// test on any overflow. Uses a long trip so the route line has to scroll.

import 'dart:io';

import 'package:dhaka_bus_vara/core/theme.dart';
import 'package:dhaka_bus_vara/data/models/bus_route.dart';
import 'package:dhaka_bus_vara/domain/fare_finder.dart';
import 'package:dhaka_bus_vara/features/route_detail/route_detail_screen.dart';
import 'package:dhaka_bus_vara/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final data = parseRouteDataset(File('assets/data/routes.json').readAsStringSync());

  for (final locale in const [Locale('bn'), Locale('en')]) {
    testWidgets('route screen fits a 360 px phone (${locale.languageCode})', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final result = findFares(data.routes, 'Kalshi', 'Kanchpur Bridge').first;
      await tester.pumpWidget(MaterialApp(
        theme: buildAppTheme(Brightness.dark),
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: RouteDetailScreen(result: result, buses: const ['Test Bus']),
      ));
      await tester.pumpAndSettle();

      expect(find.text(locale.languageCode == 'bn' ? 'যাত্রাপথ' : 'Journey'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
