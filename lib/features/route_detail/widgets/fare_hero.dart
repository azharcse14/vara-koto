import 'package:flutter/material.dart';

import '../../../core/l10n.dart';
import '../../../core/theme.dart';
import '../../../data/models/fare_result.dart';
import '../../../widgets/common.dart';

class FareHero extends StatelessWidget {
  const FareHero({super.key, required this.result});

  final FareResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stops = result.path.length;
    final segments = result.segments.length;
    return AppCard(
      color: AppColors.amberFaint,
      borderColor: AppColors.amberLine,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StopName(
                  nameBn: result.from.nameBn,
                  nameEn: result.from.nameEn,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Icon(Icons.arrow_forward, color: AppColors.amber),
              ),
              Expanded(
                child: StopName(
                  nameBn: result.to.nameBn,
                  nameEn: result.to.nameEn,
                  align: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(l10n.totalFare, style: AppText.label),
          const SizedBox(height: 6),
          Text(context.taka(result.fare), style: AppText.fareHero),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Tag(l10n.stopCount(stops, context.digits(stops))),
              _Tag(l10n.segmentCount(segments, context.digits(segments))),
              _Tag(l10n.routeLength(context.km(result.route.totalKm))),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(text, style: AppText.label),
    );
  }
}
