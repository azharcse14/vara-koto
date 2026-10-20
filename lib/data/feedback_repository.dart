import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'models/feedback_entry.dart';

enum FeedbackOutcome { sent, savedOnDevice }

abstract class FeedbackRepository {
  Future<FeedbackOutcome> submit({required String name, required String message});

  /// Sends anything still waiting in the outbox. Safe to call any time.
  Future<void> syncPending();
}

/// Feedback that hasn't reached a server yet, stored on the phone.
/// Survives app updates, so messages written in local mode are sent once a
/// server version of the app is installed.
class FeedbackOutbox {
  static const _key = 'feedback_outbox_v1';

  Future<List<FeedbackEntry>> all() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const <String>[];
    return [
      for (final item in raw)
        FeedbackEntry.fromJson(jsonDecode(item) as Map<String, dynamic>),
    ];
  }

  Future<void> add(FeedbackEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const <String>[];
    await prefs.setStringList(_key, [...raw, jsonEncode(entry.toJson())]);
  }

  Future<void> remove(Set<String> ids) async {
    if (ids.isEmpty) return;
    final current = await all();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, [
      for (final e in current)
        if (!ids.contains(e.id)) jsonEncode(e.toJson()),
    ]);
  }
}

/// Local mode: keeps feedback on the phone.
class LocalFeedbackRepository implements FeedbackRepository {
  LocalFeedbackRepository(this._outbox);

  final FeedbackOutbox _outbox;

  @override
  Future<FeedbackOutcome> submit({
    required String name,
    required String message,
  }) async {
    await _outbox.add(FeedbackEntry.create(name: name, message: message));
    return FeedbackOutcome.savedOnDevice;
  }

  @override
  Future<void> syncPending() async {}
}

/// Server mode: posts to the existing Express route POST {baseUrl}/feedback,
/// falling back to the outbox when offline.
class RemoteFeedbackRepository implements FeedbackRepository {
  RemoteFeedbackRepository({
    required this.baseUrl,
    required FeedbackOutbox outbox,
    http.Client? client,
  })  : _outbox = outbox,
        _client = client ?? http.Client();

  final String baseUrl;
  final FeedbackOutbox _outbox;
  final http.Client _client;
  bool _syncing = false;

  @override
  Future<FeedbackOutcome> submit({
    required String name,
    required String message,
  }) async {
    final entry = FeedbackEntry.create(name: name, message: message);
    if (await _post(entry)) {
      unawaited(syncPending());
      return FeedbackOutcome.sent;
    }
    await _outbox.add(entry);
    return FeedbackOutcome.savedOnDevice;
  }

  @override
  Future<void> syncPending() async {
    if (_syncing) return;
    _syncing = true;
    try {
      final sent = <String>{};
      for (final entry in await _outbox.all()) {
        if (!await _post(entry)) break; // still offline; try again next launch
        sent.add(entry.id);
      }
      await _outbox.remove(sent);
    } finally {
      _syncing = false;
    }
  }

  Future<bool> _post(FeedbackEntry entry) async {
    try {
      final res = await _client
          .post(
            Uri.parse('$baseUrl/feedback'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': entry.name,
              'message': entry.message,
              'createdAt': entry.createdAt.toIso8601String(),
            }),
          )
          .timeout(const Duration(seconds: 15));
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }
}
