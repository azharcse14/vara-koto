import 'package:flutter/material.dart';

import '../../../core/bangla_text.dart';
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
                  route.nameBn,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  route.nameEn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption,
                ),
                const SizedBox(height: 6),
                if (renamed)
                  Text(
                    'এই রুটে: ${result.from.nameBn} থেকে ${result.to.nameBn}',
                    style: AppText.label.copyWith(color: AppColors.text),
                  ),
                Text(
                  '${toBnDigits(result.path.length)}টি স্টপ',
                  style: AppText.label,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(taka(result.fare), style: AppText.fare),
              const SizedBox(height: 4),
              const Text('ভাড়া', style: AppText.caption),
            ],
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
