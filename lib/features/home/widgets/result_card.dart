import 'package:flutter/material.dart';

import '../../../core/l10n.dart';
import '../../../core/theme.dart';
import '../../../data/models/fare_result.dart';
import '../../../widgets/common.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  final FareResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final route = result.route;
    final l10n = context.l10n;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RouteBadge(route.routeNo),
                const SizedBox(height: 8),
                // The rider's own trip, in this route's spelling of the stops.
                Text(
                  '${context.name(result.from.nameBn, result.from.nameEn)} → '
                  '${context.name(result.to.nameBn, result.to.nameEn)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.body.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  l10n.busRoute(context.name(route.nameBn, route.nameEn)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.caption,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.stopCount(
                      result.path.length, context.digits(result.path.length)),
                  style: context.text.label,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(context.taka(result.fare), style: context.text.fare),
              const SizedBox(height: 4),
              Text(l10n.fare, style: context.text.caption),
            ],
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, color: context.colors.textMuted),
        ],
      ),
    );
  }
}
