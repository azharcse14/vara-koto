import 'package:flutter/material.dart';

import '../../../core/l10n.dart';
import '../../../core/theme.dart';
import '../../../data/models/fare_result.dart';
import '../../../widgets/common.dart';

/// The official fare for each hop between neighbouring stops, like the web
/// app's "Stop-wise Fare" card.
///
/// The hops don't add up to the trip fare: the chart is distance-based with a
/// ৳10 minimum, so a long ride costs less than the sum of its short hops. The
/// note under the list says so, so nobody pays the sum.
class StopwiseList extends StatelessWidget {
  const StopwiseList({super.key, required this.result});

  final FareResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final segments = result.segments;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(l10n.stopwiseTitle, style: context.text.bodyStrong)),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(l10n.stopwiseSubtitle,
                      textAlign: TextAlign.end, style: context.text.caption),
                ),
              ],
            ),
          ),
          for (final s in segments) ...[
            Divider(height: 1, color: context.colors.border),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: StopName(
                      nameBn: s.from.nameBn,
                      nameEn: s.from.nameEn,
                      style: context.text.body.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.arrow_forward, size: 16, color: context.colors.textMuted),
                  ),
                  Expanded(
                    child: StopName(
                      nameBn: s.to.nameBn,
                      nameEn: s.to.nameEn,
                      style: context.text.body.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    context.taka(s.fare),
                    style: context.text.bodyStrong.copyWith(color: context.colors.amber),
                  ),
                ],
              ),
            ),
          ],
          if (segments.length > 1) ...[
            Divider(height: 1, color: context.colors.border),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.segmentsDontAdd(context.taka(result.fare)),
                style: context.text.caption,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
