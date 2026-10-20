// Logic tests against the real assets/data/routes.json.
// Run with: flutter test
//
// (Named widget_test.dart so `flutter create .` doesn't add its counter-app
// sample test, which wouldn't compile against this app.)

import 'dart:io';

import 'package:dhaka_bus_vara/core/bangla_text.dart';
import 'package:dhaka_bus_vara/data/models/bus_route.dart';
import 'package:dhaka_bus_vara/data/models/stop_entry.dart';
import 'package:dhaka_bus_vara/domain/fare_finder.dart';
import 'package:dhaka_bus_vara/domain/stop_index.dart';
import 'package:dhaka_bus_vara/domain/stop_search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RouteDataset data;
  late List<StopEntry> stops;

  StopEntry stop(String nameEn) => stops.firstWhere((s) => s.nameEn == nameEn);

  setUpAll(() {
    data = parseRouteDataset(File('assets/data/routes.json').readAsStringSync());
    stops = buildStopIndex(data.routes);
  });

  group('dataset', () {
    test('loads every route and stop', () {
      expect(data.routes.length, 124);
      expect(data.routes.map((r) => r.id).toSet().length, 120);
      expect(stops.length, 371);
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
          ['A280:Kalshi Mor:24', 'A101:Kalshi:31']);
    });

    test('Mirpur-1 to Farmgate only uses Mirpur-1 (old server showed 14 routes)', () {
      final results = findFares(data.routes, 'Mirpur-1', 'Farmgate');
      expect(results.length, 4);
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
      expect(results.map((r) => r.from.nameEn), contains('Kanchpur Bridge'));
      expect(results.map((r) => r.from.nameEn), contains('Kanchpur'));
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

    test('results are sorted cheapest first', () {
      final results = findFares(data.routes, 'Mirpur-10', 'Farmgate');
      expect(results.length, greaterThan(1));
      for (var i = 1; i < results.length; i++) {
        expect(results[i].fare, greaterThanOrEqualTo(results[i - 1].fare));
      }
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
      expect(formatKmBn(28.8), '২৮.৮');
      expect(formatKmBn(15), '১৫');
    });
  });
}
