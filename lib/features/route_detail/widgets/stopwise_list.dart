import 'package:flutter/material.dart';

import '../../../core/l10n.dart';
import '../../../core/theme.dart';
import '../../../data/models/fare_result.dart';
import '../../../widgets/common.dart';

const _rowHeight = 64.0;

/// Every stop in the direction of travel. The right column is what you pay
/// from the boarding stop if you get off there; the small line is the fare
/// for just the previous segment (the web app's "stop-wise fare" table).
///
/// The two don't add up: the official chart is distance-based with a ৳10
/// minimum, so a long ride costs less than the sum of its short hops.
class StopwiseList extends StatelessWidget {
  const StopwiseList({super.key, required this.result});

  final FareResult result;

  @override
  Widget build(BuildContext context) {
    final path = result.path;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          for (var i = 0; i < path.length; i++)
            _StopRow(
              nameBn: path[i].nameBn,
              nameEn: path[i].nameEn,
              isFirst: i == 0,
              isLast: i == path.length - 1,
              fareFromStart: i == 0 ? null : result.fareTo(path[i]),
              segmentFare: i == 0 ? null : result.segments[i - 1].fare,
            ),
        ],
      ),
    );
  }
}

class _StopRow extends StatelessWidget {
  const _StopRow({
    required this.nameBn,
    required this.nameEn,
    required this.isFirst,
    required this.isLast,
    required this.fareFromStart,
    required this.segmentFare,
  });

  final String nameBn;
  final String nameEn;
  final bool isFirst;
  final bool isLast;
  final int? fareFromStart;
  final int? segmentFare;

  @override
  Widget build(BuildContext context) {
    final dotColor = isFirst
        ? context.colors.green
        : isLast
            ? context.colors.red
            : context.colors.textMuted;
    final endpoint = isFirst || isLast;
    final l10n = context.l10n;

    return SizedBox(
      height: _rowHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 16,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst ? Colors.transparent : context.colors.rail,
                  ),
                ),
                Container(
                  width: endpoint ? 14 : 10,
                  height: endpoint ? 14 : 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: endpoint ? context.colors.bg : dotColor,
                    border: endpoint
                        ? Border.all(color: dotColor, width: 3.5)
                        : null,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : context.colors.rail,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: context.name(nameBn, nameEn),
                      style: endpoint
                          ? context.text.bodyStrong
                          : context.text.body.copyWith(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                        text: '  ${context.altName(nameBn, nameEn)}',
                        style: context.text.caption),
                  ]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  segmentFare == null
                      ? l10n.getOnHere
                      : l10n.fromPreviousStop(context.taka(segmentFare!)),
                  style: context.text.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Center(
            child: fareFromStart == null
                ? const SizedBox.shrink()
                : Text(
                    context.taka(fareFromStart!),
                    style: TextStyle(
                      fontSize: isLast ? 20 : 16,
                      fontWeight: isLast ? FontWeight.w700 : FontWeight.w600,
                      color: isLast ? context.colors.amber : context.colors.text,
                    ),
                    semanticsLabel:
                        l10n.fareToHere(context.digits(fareFromStart!)),
                  ),
          ),
        ],
      ),
    );
  }
}
