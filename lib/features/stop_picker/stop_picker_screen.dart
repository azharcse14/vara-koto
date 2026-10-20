import 'package:flutter/material.dart';

import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/fare_repository.dart';
import '../../data/models/stop_entry.dart';

/// Full-screen search. Returns the chosen [StopEntry] via Navigator.pop.
class StopPickerScreen extends StatefulWidget {
  const StopPickerScreen(
      {super.key, required this.fares, required this.label, this.exclude});

  final FareRepository fares;

  /// "From" or "To", in the app's language.
  final String label;

  /// The stop already picked on the other side, left out of the list.
  final StopEntry? exclude;

  @override
  State<StopPickerScreen> createState() => _StopPickerScreenState();
}

class _StopPickerScreenState extends State<StopPickerScreen> {
  final _query = TextEditingController();
  late List<StopEntry> _results = _withoutExcluded(widget.fares.stops);

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(
        () => _results = _withoutExcluded(widget.fares.searchStops(value)));
  }

  List<StopEntry> _withoutExcluded(List<StopEntry> stops) =>
      stops.where((s) => s != widget.exclude).toList();

  void _clear() {
    _query.clear();
    _onChanged('');
  }

  void _choose(StopEntry stop) => Navigator.of(context).pop(stop);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _query,
          autofocus: true,
          onChanged: _onChanged,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) {
            if (_results.isNotEmpty) _choose(_results.first);
          },
          style: context.text.bodyStrong,
          cursorColor: context.colors.amber,
          decoration: InputDecoration(
            hintText: l10n.searchHint(widget.label),
            hintStyle:
                context.text.body.copyWith(color: context.colors.textMuted),
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_query.text.isNotEmpty)
            IconButton(
              tooltip: l10n.clear,
              onPressed: _clear,
              icon: const Icon(Icons.close),
            ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: _results.isEmpty
          ? _NoMatch(query: _query.text.trim())
          : ListView.separated(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: _results.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 56),
              itemBuilder: (context, index) {
                final stop = _results[index];
                return ListTile(
                  onTap: () => _choose(stop),
                  leading: Icon(Icons.place_outlined,
                      color: context.colors.textSecondary),
                  title: Text(context.name(stop.nameBn, stop.nameEn),
                      style: context.text.bodyStrong),
                  subtitle: Text(context.altName(stop.nameBn, stop.nameEn),
                      style: context.text.label),
                  trailing: Text(
                    l10n.routeCount(
                        stop.routeCount, context.digits(stop.routeCount)),
                    style: context.text.caption,
                  ),
                );
              },
            ),
    );
  }
}

class _NoMatch extends StatelessWidget {
  const _NoMatch({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.noStopFound(query), style: context.text.bodyStrong),
          const SizedBox(height: 6),
          Text(l10n.noStopFoundHint, style: context.text.label),
        ],
      ),
    );
  }
}
