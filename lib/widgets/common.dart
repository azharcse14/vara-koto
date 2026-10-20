import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/theme.dart';

/// Translucent card with a hairline border. Tappable when [onTap] is set.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.radius = 20,
    this.color,
    this.borderColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double radius;
  /// Defaults to the theme's card and border colors.
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Material(
      color: color ?? context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: borderColor ?? context.colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}

/// Route number pill, e.g. "এ-১০১".
class RouteBadge extends StatelessWidget {
  const RouteBadge(this.routeNo, {super.key});

  final String routeNo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: context.colors.amberSoft,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.amberLine),
      ),
      child: Text(
        routeNo,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 13,
          height: 1.4,
          fontWeight: FontWeight.w700,
          color: context.colors.amber,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.text.bodyStrong),
          if (subtitle != null) Text(subtitle!, style: context.text.caption),
        ],
      ),
    );
  }
}

/// The name in the app's language, with the other language's name below it
/// in a smaller, quieter style.
class StopName extends StatelessWidget {
  const StopName({
    super.key,
    required this.nameBn,
    required this.nameEn,
    this.style,
    this.align = CrossAxisAlignment.start,
  });

  final String nameBn;
  final String nameEn;
  /// Defaults to bodyStrong.
  final TextStyle? style;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    final textAlign =
        align == CrossAxisAlignment.end ? TextAlign.end : TextAlign.start;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(context.name(nameBn, nameEn),
            style: style ?? context.text.bodyStrong, textAlign: textAlign),
        Text(context.altName(nameBn, nameEn),
            style: context.text.label, textAlign: textAlign),
      ],
    );
  }
}
