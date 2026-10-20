import 'package:flutter/material.dart';

import '../../../core/l10n.dart';
import '../../../core/theme.dart';
import '../../../data/models/bus_route.dart';

const _cellWidth = 64.0;
const _rowHeadWidth = 116.0;
const _cellHeight = 40.0;
const _headHeight = 58.0;

/// The route's full fare chart. Rows and columns for the two chosen stops are
/// tinted, and the cell where they meet is solid amber.
class FareMatrixTable extends StatelessWidget {
  const FareMatrixTable({
    super.key,
    required this.route,
    required this.highlightA,
    required this.highlightB,
  });

  final BusRoute route;
  final int highlightA;
  final int highlightB;

  bool _isPicked(int i) => i == highlightA || i == highlightB;

  @override
  Widget build(BuildContext context) {
    final stops = route.stops;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          child: Table(
            defaultColumnWidth: const FixedColumnWidth(_cellWidth),
            columnWidths: const {0: FixedColumnWidth(_rowHeadWidth)},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                SizedBox(
                  height: _headHeight,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
                      child: Text(context.l10n.matrixCorner,
                          style: context.text.caption),
                    ),
                  ),
                ),
                for (var j = 0; j < stops.length; j++)
                  _HeadCell(context.name(stops[j].nameBn, stops[j].nameEn),
                      picked: _isPicked(j)),
              ]),
              for (var i = 0; i < stops.length; i++)
                TableRow(children: [
                  _RowHead(context.name(stops[i].nameBn, stops[i].nameEn),
                      picked: _isPicked(i)),
                  for (var j = 0; j < stops.length; j++) _cell(context, i, j),
                ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cell(BuildContext context, int i, int j) {
    final isSelf = i == j;
    final isTarget = (i == highlightA && j == highlightB) ||
        (i == highlightB && j == highlightA);
    final inPickedLine = !isSelf && (_isPicked(i) || _isPicked(j));

    final Color background;
    final TextStyle style;
    if (isTarget) {
      background = context.colors.amber;
      style = TextStyle(
          fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.onAmber);
    } else if (inPickedLine) {
      background = context.colors.amberFaint;
      style = TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600, color: context.colors.text);
    } else {
      background = Colors.transparent;
      style = TextStyle(
          fontSize: 13,
          color: isSelf ? context.colors.textMuted : context.colors.textSecondary);
    }

    return Container(
      height: _cellHeight,
      margin: const EdgeInsets.all(1),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(isSelf ? '—' : context.taka(route.fareBetween(i, j)),
          style: style),
    );
  }
}

class _HeadCell extends StatelessWidget {
  const _HeadCell(this.name, {required this.picked});

  final String name;
  final bool picked;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _headHeight,
      padding: const EdgeInsets.symmetric(horizontal: 3),
      alignment: Alignment.bottomCenter,
      child: Text(
        name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          height: 1.3,
          fontWeight: picked ? FontWeight.w700 : FontWeight.w500,
          color: picked ? context.colors.amber : context.colors.textSecondary,
        ),
      ),
    );
  }
}

class _RowHead extends StatelessWidget {
  const _RowHead(this.name, {required this.picked});

  final String name;
  final bool picked;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cellHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          height: 1.25,
          fontWeight: picked ? FontWeight.w700 : FontWeight.w500,
          color: picked ? context.colors.amber : context.colors.text,
        ),
      ),
    );
  }
}
