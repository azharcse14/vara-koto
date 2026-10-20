import 'package:flutter/material.dart';

import '../../core/bangla_text.dart';
import '../../core/theme.dart';
import '../../data/fare_repository.dart';
import '../../data/models/stop_entry.dart';

/// Full-screen search. Returns the chosen [StopEntry] via Navigator.pop.
class StopPickerScreen extends StatefulWidget {
  const StopPickerScreen({super.key, required this.fares, required this.label});

  final FareRepository fares;

  /// "যাত্রা শুরু" or "গন্তব্য".
  final String label;

  @override
  State<StopPickerScreen> createState() => _StopPickerScreenState();
}

class _StopPickerScreenState extends State<StopPickerScreen> {
  final _query = TextEditingController();
  late List<StopEntry> _results = widget.fares.stops;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _results = widget.fares.searchStops(value));
  }

  void _clear() {
    _query.clear();
    _onChanged('');
  }

  void _choose(StopEntry stop) => Navigator.of(context).pop(stop);

  @override
  Widget build(BuildContext context) {
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
          style: AppText.bodyStrong,
          cursorColor: AppColors.amber,
          decoration: InputDecoration(
            hintText: '${widget.label}: স্টপের নাম বা রুট নম্বর',
            hintStyle: AppText.body.copyWith(color: AppColors.textMuted),
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_query.text.isNotEmpty)
            IconButton(
              tooltip: 'মুছে ফেলুন',
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
                  leading: const Icon(Icons.place_outlined,
                      color: AppColors.textSecondary),
                  title: Text(stop.nameBn, style: AppText.bodyStrong),
                  subtitle: Text(stop.nameEn, style: AppText.label),
                  trailing: Text(
                    '${toBnDigits(stop.routeCount)}টি রুট',
                    style: AppText.caption,
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('“$query” নামে কোনো স্টপ পাওয়া যায়নি', style: AppText.bodyStrong),
          const SizedBox(height: 6),
          const Text(
            'বানান একটু বদলে লিখুন, অথবা বাংলায় বা ইংরেজিতে চেষ্টা করুন। '
            'রুট নম্বর দিয়েও খোঁজা যায়, যেমন ১০১।',
            style: AppText.label,
          ),
        ],
      ),
    );
  }
}
