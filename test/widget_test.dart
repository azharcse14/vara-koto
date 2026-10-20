// Logic tests against the real assets/data/routes.json.
// Run with: flutter test
//
// (Named widget_test.dart so `flutter create .` doesn't add its counter-app
// sample test, which wouldn't compile against this app.)

import 'dart:io';

import 'package:dhaka_bus_vara/core/bangla_text.dart';
import 'package:dhaka_bus_vara/data/fare_repository.dart';
import 'package:dhaka_bus_vara/data/models/bus_route.dart';
import 'package:dhaka_bus_vara/data/models/stop_entry.dart';
import 'package:dhaka_bus_vara/domain/fare_finder.dart';
import 'package:dhaka_bus_vara/domain/stop_index.dart';
import 'package:dhaka_bus_vara/domain/stop_search.dart';
import 'package:dhaka_bus_vara/data/sources/route_data_source.dart';
import 'package:dhaka_bus_vara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  late RouteDataset data;
  late List<StopEntry> stops;

  setUpAll(() {
    data = parseRouteDataset(File('assets/data/routes.json').readAsStringSync());
    stops = buildStopIndex(data.routes);
  });

  group('dataset', () {
    test('loads every route and stop', () {
      expect(data.routes.length, 135);
      expect(data.routes.map((r) => r.id).toSet().length, 135);
      expect(stops.length, 336);
    });

    test('has the date the data last changed, shown in Bangla in About', () async {
      expect(data.updated, isNotNull);
      await initializeDateFormatting('bn');
      final bn = await AppLocalizations.delegate.load(const Locale('bn'));
      expect(bn.dataUpdated(DateTime(2026, 10, 20)), 'ডেটা সর্বশেষ হালনাগাদ: ২০ অক্টোবর, ২০২৬');
    });

    test('uses the printed fares of the 22 Sep 2026 BRTA chart', () {
      int fare(String id, String from, String to) {
        final r = data.routes.firstWhere((r) => r.id == id);
        return r.fareBetween(r.indexOfStop(from), r.indexOfStop(to));
      }

      // The earlier data had 18 here; the chart prints 14.
      expect(fare('A101', 'Farmgate', 'Gulistan'), 14);
      // Printed 10, though 3.9 km x 2.70 rounds to 11.
      expect(fare('A101', 'Mirpur-12', 'Kazipara'), 10);
      // Printed 8, below the chart's own 10 taka minimum; stored as 10.
      final a341 = data.routes.firstWhere((r) => r.id == 'A341');
      expect(a341.fareMatrix.expand((row) => row).where((f) => f > 0 && f < 10), isEmpty);
    });

    test('every matrix is square and symmetric', () {
      for (final r in data.routes) {
        expect(r.fareMatrix.length, r.stops.length, reason: r.id);
        for (var i = 0; i < r.stops.length; i++) {
          expect(r.fareMatrix[i].length, r.stops.length, reason: r.id);
          for (var j = 0; j < r.stops.length; j++) {
            expect(r.fareMatrix[i][j], r.fareMatrix[j][i], reason: '${r.id} $i,$j');
          }
        }
      }
    });
  });

  group('findFares', () {
    bool sameStop(RouteStop stop, String name) =>
        stop.nameEn == name ||
        stop.aliases.any((a) => a.toLowerCase() == name.toLowerCase());

    test('Kalshi to Farmgate: A101 at ৳31, and A280 via Kalshi Mor at ৳24', () {
      final results = findFares(data.routes, 'Kalshi', 'Farmgate');
      expect(results.map((r) => '${r.route.id}:${r.from.nameEn}:${r.fare}'),
          ['A101:Kalshi:31', 'A280:Kalshi Mor:24']);
    });

    test('Mirpur-1 to Farmgate only uses Mirpur-1 (old server showed 14 routes)', () {
      final results = findFares(data.routes, 'Mirpur-1', 'Farmgate');
      expect(results.length, 5);
      for (final r in results) {
        expect(r.from.nameEn, 'Mirpur-1', reason: r.route.id);
        expect(r.fare, 19, reason: r.route.id);
      }
    });

    test('never partial-matches; only exact names or exact aliases', () {
      for (final from in ['Mirpur-1', 'Mirpur-10', 'Kanchpur', 'Kalshi']) {
        for (final to in ['Farmgate', 'Gulistan', 'Motijheel']) {
          for (final r in findFares(data.routes, from, to)) {
            expect(sameStop(r.from, from), isTrue, reason: '${r.route.id} ${r.from.nameEn}');
            expect(sameStop(r.to, to), isTrue, reason: '${r.route.id} ${r.to.nameEn}');
          }
        }
      }
    });

    test('spelling variants linked by aliases are found', () {
      final results = findFares(data.routes, 'Kanchpur', 'Gulistan');
      expect(results, isNotEmpty);
      expect(results.map((r) => r.from.nameEn).toSet(), {'Kanchpur Bridge'});
    });

    test('reverse trip has the same fare and reversed path', () {
      final there = findFares(data.routes, 'Kalshi', 'Farmgate');
      final back = findFares(data.routes, 'Farmgate', 'Kalshi');
      expect(back.length, there.length);
      for (final t in there) {
        final b = back.firstWhere((x) => x.route.id == t.route.id);
        expect(b.fare, t.fare);
        expect(b.path.map((s) => s.nameEn), t.path.reversed.map((s) => s.nameEn));
      }
    });

    test('drops duplicate route entries', () {
      final results = findFares(data.routes, 'Fulbaria', 'Dhamrai');
      expect(results.where((r) => r.route.id == 'A260').length, 1);
    });

    test('Kalshi to Mirpur-10: A101 first at ৳13, like the web', () {
      final first = findFares(data.routes, 'Kalshi', 'Mirpur-10').first;
      expect(first.route.id, 'A101');
      expect(first.fare, 13);
      expect(first.path.length, 3);
    });

    test('same stop or unknown stop gives no result', () {
      expect(findFares(data.routes, 'Kalshi', 'Kalshi'), isEmpty);
      expect(findFares(data.routes, 'Kalshi', 'Nowhere'), isEmpty);
    });
  });

  group('searchStops', () {
    test('English, Bangla and mixed digits find Mirpur-10 first', () {
      for (final q in ['Mirpur-10', 'mirpur 10', 'mirpur10', 'মিরপুর-১০', 'মিরপুর ১০', 'mirpur ১০']) {
        expect(searchStops(stops, q).first.nameEn, 'Mirpur-10', reason: q);
      }
    });

    test('partial and misspelled-with-spaces names still match', () {
      expect(searchStops(stops, 'farmgat').map((s) => s.nameEn), contains('Farmgate'));
      expect(searchStops(stops, 'farm gate').first.nameEn, 'Farmgate');
    });

    test('route number finds stops on that route', () {
      final a101 = data.routes.firstWhere((r) => r.id == 'A101');
      for (final q in ['১০১', 'A-101', 'a101', 'এ-১০১']) {
        final names = searchStops(stops, q).map((s) => s.nameEn).toSet();
        expect(names, containsAll(a101.stops.map((s) => s.nameEn)), reason: q);
      }
    });

    test('empty query returns everything, nonsense returns nothing', () {
      expect(searchStops(stops, '  ').length, stops.length);
      expect(searchStops(stops, 'zzzzqqq'), isEmpty);
    });
  });

  group('bangla text', () {
    test('digits convert both ways', () {
      expect(toBnDigits(2026), '২০২৬');
      expect(toEnDigits('মিরপুর-১০'), 'মিরপুর-10');
    });

    test('route keys normalize', () {
      expect(normalizeRouteKey('এ-১০১'), 'a101');
      expect(normalizeRouteKey('A 101'), 'a101');
      expect(normalizeRouteKey('BAIPAIL_KERANIGANJ'), 'baipailkeraniganj');
    });

    test('km formatting', () {
      expect(formatKm(28.8), '২৮.৮');
      expect(formatKm(15), '১৫');
      expect(formatKm(28.8, bn: false), '28.8');
    });

    test('taka uses the app language digits', () {
      expect(taka(10), '৳১০');
      expect(taka(10, bn: false), '৳10');
    });
  });

  group('buses', () {
    Bus bus(String name) => data.buses.firstWhere((b) => b.name == name);

    test('loads the unofficial bus list', () {
      expect(data.buses.length, 196);
    });

    test('matches stops by alias and by the spelling map', () {
      expect(bus('Achim Paribahan').serves('Kalshi', 'Mirpur-10'), isTrue);
      // CSV says "Jashimuddin (Uttara)", mapped in tool/add_buses.js.
      expect(bus('Azmeri Glory Limited').serves('Jashimuddin', 'Banani'), isTrue);
      expect(bus('Achim Paribahan').serves('Kalshi', 'Sadarghat'), isFalse);
      // CSV ends D Link at "Fulbaria"; SAME_PLACE joins it to Gulistan.
      expect(bus('D Link').serves('Dhamrai', 'Gulistan'), isTrue);
    });

    test('lists only buses that follow the fare route\'s road', () async {
      final repo = FareRepository(_Fixed(data));
      await repo.init();
      List<String> buses(String from, String to) => repo.busesFor(
          findFares(data.routes, from, to).first);

      // A356 goes via Mirpur-1; Safety Druti goes via Kazipara.
      expect(buses('Mirpur-12', 'New Market'), isNot(contains('Safety Druti')));
      expect(buses('Mirpur-12', 'Agargaon'), contains('Safety Druti'));
      // A397 goes via Farmgate; D Link goes via New Market.
      expect(buses('Dhamrai', 'Gulistan'), isNot(contains('D Link')));
    });
  });
}

class _Fixed implements RouteDataSource {
  _Fixed(this.data);

  final RouteDataset data;

  @override
  Future<RouteDataset> load() async => data;

  @override
  Future<RouteDataset?> refresh(String currentVersion) async => null;
}
