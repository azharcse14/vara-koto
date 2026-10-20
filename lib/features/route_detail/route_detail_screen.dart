import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/models/fare_result.dart';
import '../../widgets/common.dart';
import 'widgets/fare_hero.dart';
import 'widgets/fare_matrix_table.dart';
import 'widgets/stopwise_list.dart';

class RouteDetailScreen extends StatelessWidget {
  const RouteDetailScreen({super.key, required this.result});

  final FareResult result;

  @override
  Widget build(BuildContext context) {
    final route = result.route;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            RouteBadge(route.routeNo),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                route.nameBn,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyStrong,
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
          const SectionHeader(
            title: 'স্টপওয়ারি ভাড়া / Stop-wise fare',
            subtitle: 'যে স্টপে নামবেন, সেখান পর্যন্ত সরকারি ভাড়া',
          ),
          StopwiseList(result: result),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'সম্পূর্ণ ভাড়া ম্যাট্রিক্স / Full fare matrix',
            subtitle: 'এই রুটের যেকোনো দুই স্টপের ভাড়া। ডানে-বামে সরিয়ে দেখুন।',
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
