import 'package:flutter/material.dart';

import '../../../core/l10n.dart';
import '../../../core/theme.dart';
import '../../../data/models/bus_route.dart';
import '../../../data/models/fare_result.dart';
import '../../../widgets/common.dart';

/// The trip, its total fare and the stops on the way, laid out like the web
/// app's journey card.
class FareHero extends StatelessWidget {
  const FareHero({super.key, required this.result});

  final FareResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stops = result.path.length;
    final segments = result.segments.length;
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.journey, style: context.text.label),
                    const SizedBox(height: 8),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 4,
                      children: [
                        StopName(nameBn: result.from.nameBn, nameEn: result.from.nameEn),
                        Icon(Icons.arrow_forward, color: context.colors.amber),
                        StopName(nameBn: result.to.nameBn, nameEn: result.to.nameEn),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(l10n.totalFare, style: context.text.label),
                  const SizedBox(height: 4),
                  Text(context.taka(result.fare), style: context.text.fareHero),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Tag(Icons.place_outlined, l10n.stopCount(stops, context.digits(stops))),
              _Tag(Icons.linear_scale, l10n.segmentCount(segments, context.digits(segments))),
            ],
          ),
          const SizedBox(height: 16),
          _RouteLine(path: result.path),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final green = context.colors.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.greenLine),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: green),
          const SizedBox(width: 4),
          Flexible(
            child: Text(text,
                overflow: TextOverflow.ellipsis, style: context.text.label.copyWith(color: green)),
          ),
        ],
      ),
    );
  }
}

/// Every stop on the trip as a dot on one line, boarding and alighting stops
/// highlighted. Scrolls sideways on long trips so labels never overlap.
class _RouteLine extends StatelessWidget {
  const _RouteLine({required this.path});

  final List<RouteStop> path;

  static const _stopWidth = 84.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.routeLabel, style: context.text.label),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < path.length; i++)
                  SizedBox(
                    width: _stopWidth,
                    child: _RouteStop(
                      stop: path[i],
                      endpoint: i == 0 || i == path.length - 1,
                      lineBefore: i > 0,
                      lineAfter: i < path.length - 1,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteStop extends StatelessWidget {
  const _RouteStop({
    required this.stop,
    required this.endpoint,
    required this.lineBefore,
    required this.lineAfter,
  });

  final RouteStop stop;
  final bool endpoint;
  final bool lineBefore;
  final bool lineAfter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget line(bool show) => Expanded(
          child: Container(height: 2, color: show ? colors.rail : Colors.transparent),
        );
    final dot = endpoint ? 14.0 : 8.0;
    return Column(
      children: [
        SizedBox(
          height: 14,
          child: Row(
            children: [
              line(lineBefore),
              Container(
                width: dot,
                height: dot,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: endpoint ? colors.amber : colors.textMuted,
                ),
              ),
              line(lineAfter),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            context.name(stop.nameBn, stop.nameEn),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: endpoint
                ? context.text.caption.copyWith(color: colors.amber, fontWeight: FontWeight.w700)
                : context.text.caption,
          ),
        ),
      ],
    );
  }
}
