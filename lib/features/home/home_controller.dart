import 'package:flutter/foundation.dart';

import '../../data/fare_repository.dart';
import '../../data/models/fare_result.dart';
import '../../data/models/stop_entry.dart';

/// Why a search has no results.
enum SearchIssue { sameStop, noCommonRoute }

/// Search state for the home screen. Fares are recalculated as soon as both
/// stops are chosen, so there is no separate "find fare" step.
class HomeController extends ChangeNotifier {
  HomeController(this._fares);

  final FareRepository _fares;

  StopEntry? _from;
  StopEntry? _to;
  List<FareResult> _results = const [];
  SearchIssue? _issue;

  StopEntry? get from => _from;
  StopEntry? get to => _to;
  List<FareResult> get results => _results;

  /// Why there are no results, when that's the case.
  SearchIssue? get issue => _issue;

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
    _issue = null;

    final from = _from;
    final to = _to;
    if (from != null && to != null) {
      if (from == to) {
        _issue = SearchIssue.sameStop;
      } else {
        // Like the web app: only the first route in routes.json order.
        _results = _fares.findFares(from, to).take(1).toList();
        if (_results.isEmpty) _issue = SearchIssue.noCommonRoute;
      }
    }
    notifyListeners();
  }
}
