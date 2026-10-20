import 'package:flutter/material.dart';

import '../../../core/l10n.dart';
import '../../../core/theme.dart';
import '../../../data/models/fare_result.dart';
import '../../../widgets/common.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.result,
    required this.chosenFrom,
    required this.chosenTo,
    required this.onTap,
  });

  final FareResult result;

  /// English names the rider picked. When this route spells a stop
  /// differently (matched through an alias), the card shows its own names.
  final String chosenFrom;
  final String chosenTo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final route = result.route;
    final l10n = context.l10n;
    final renamed =
        result.from.nameEn != chosenFrom || result.to.nameEn != chosenTo;
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
                Text(
                  context.name(route.nameBn, route.nameEn),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.body.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  context.altName(route.nameBn, route.nameEn),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.caption,
                ),
                const SizedBox(height: 6),
                if (renamed)
                  Text(
                    l10n.onThisRoute(
                      context.name(result.from.nameBn, result.from.nameEn),
                      context.name(result.to.nameBn, result.to.nameEn),
                    ),
                    style: context.text.label.copyWith(color: context.colors.text),
                  ),
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
