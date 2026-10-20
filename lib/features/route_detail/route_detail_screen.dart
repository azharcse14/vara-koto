import 'package:flutter/material.dart';

import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/models/fare_result.dart';
import '../../widgets/common.dart';
import 'widgets/bus_list.dart';
import 'widgets/fare_hero.dart';
import 'widgets/fare_matrix_table.dart';
import 'widgets/stopwise_list.dart';

class RouteDetailScreen extends StatelessWidget {
  const RouteDetailScreen({
    super.key,
    required this.result,
    required this.buses,
  });

  final FareResult result;
  final List<String> buses;

  @override
  Widget build(BuildContext context) {
    final route = result.route;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            RouteBadge(route.routeNo),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                context.name(route.nameBn, route.nameEn),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodyStrong,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 32 + bottomInset),
        children: [
          FareHero(result: result),
          const SizedBox(height: 28),
          SectionHeader(title: l10n.busesTitle, subtitle: l10n.busesSubtitle),
          BusList(result: result, buses: buses),
          const SizedBox(height: 28),
          SectionHeader(
            title: l10n.stopwiseTitle,
            subtitle: l10n.stopwiseSubtitle,
          ),
          StopwiseList(result: result),
          const SizedBox(height: 28),
          SectionHeader(
            title: l10n.matrixTitle,
            subtitle: l10n.matrixSubtitle,
          ),
          FareMatrixTable(
            route: route,
            highlightA: result.fromIndex,
            highlightB: result.toIndex,
          ),
        ],
      ),
    );
  }
}
