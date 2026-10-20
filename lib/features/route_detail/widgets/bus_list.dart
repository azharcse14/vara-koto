import 'package:flutter/material.dart';

import '../../../core/l10n.dart';
import '../../../core/theme.dart';
import '../../../data/models/fare_result.dart';
import '../../../widgets/common.dart';

/// Buses that stop at both ends of the trip, from an unofficial list. The
/// note says plainly that a bus may take another road, so the fare above
/// (BRTA's, for this route) may not be what that bus charges.
class BusList extends StatelessWidget {
  const BusList({super.key, required this.result, required this.buses});

  final FareResult result;
  final List<String> buses;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final from = context.name(result.from.nameBn, result.from.nameEn);
    final to = context.name(result.to.nameBn, result.to.nameEn);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (buses.isEmpty)
            Text(l10n.busesNone, style: context.text.body)
          else ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final bus in buses)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.colors.border),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(bus, style: context.text.body),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.busesNote(from, to, result.route.routeNo),
              style: context.text.label,
            ),
          ],
        ],
      ),
    );
  }
}
