import 'package:flutter/foundation.dart';

import '../../data/fare_repository.dart';
import '../../data/models/fare_result.dart';
import '../../data/models/stop_entry.dart';

/// Search state for the home screen. Fares are recalculated as soon as both
/// stops are chosen, so there is no separate "find fare" step.
class HomeController extends ChangeNotifier {
  HomeController(this._fares);

  final FareRepository _fares;

  StopEntry? _from;
  StopEntry? _to;
  List<FareResult> _results = const [];
  String? _message;

  StopEntry? get from => _from;
  StopEntry? get to => _to;
  List<FareResult> get results => _results;

  /// Explains why there are no results, when that's the case.
  String? get message => _message;

  void setFrom(StopEntry stop) {
    _from = stop;
    _recalculate();
  }

  void setTo(StopEntry stop) {
    _to = stop;
    _recalculate();
  }

  void swap() {
    final previousFrom = _from;
    _from = _to;
    _to = previousFrom;
    _recalculate();
  }

  /// Called when fare data is refreshed from the server.
  void onDataChanged() {
    if (_from != null && _to != null) _recalculate();
  }

  void _recalculate() {
    _results = const [];
    _message = null;

    final from = _from;
    final to = _to;
    if (from != null && to != null) {
      if (from == to) {
        _message = 'যাত্রার স্থান ও গন্তব্য একই হতে পারবে না।';
      } else {
        _results = _fares.findFares(from, to);
        if (_results.isEmpty) {
          _message = '“${from.nameBn}” ও “${to.nameBn}” একই রুটে পড়ে না। '
              'কাছাকাছি অন্য কোনো স্টপ বেছে দেখুন।';
        }
      }
    }
    notifyListeners();
  }
}
