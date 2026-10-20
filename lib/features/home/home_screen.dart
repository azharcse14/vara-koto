import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_services.dart';
import '../../core/app_settings.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/fare_repository.dart';
import '../../data/models/fare_result.dart';
import '../../data/models/stop_entry.dart';
import '../../widgets/common.dart';
import '../about/about_screen.dart';
import '../feedback/feedback_screen.dart';
import '../route_detail/route_detail_screen.dart';
import '../settings/settings_sheet.dart';
import '../stop_picker/stop_picker_screen.dart';
import 'home_controller.dart';
import 'widgets/result_card.dart';
import 'widgets/search_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.services, required this.settings});

  final AppServices services;
  final AppSettings settings;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FareRepository _fares = widget.services.fares;
  late final HomeController _controller = HomeController(_fares);

  @override
  void initState() {
    super.initState();
    _fares.addListener(_controller.onDataChanged);
  }

  @override
  void dispose() {
    _fares.removeListener(_controller.onDataChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickStop({required bool isFrom}) async {
    final picked = await Navigator.of(context).push(
      MaterialPageRoute<StopEntry>(
        builder: (_) => StopPickerScreen(
          fares: _fares,
          label: isFrom ? context.l10n.fromLabel : context.l10n.toLabel,
        ),
      ),
    );
    if (picked == null || !mounted) return;
    if (isFrom) {
      _controller.setFrom(picked);
      // Most people pick both stops in a row, so go straight to the next one.
      if (_controller.to == null) await _pickStop(isFrom: false);
    } else {
      _controller.setTo(picked);
    }
  }

  void _openDetail(FareResult result) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => RouteDetailScreen(result: result)),
    );
  }

  void _openFeedback() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FeedbackScreen(
          repository: widget.services.feedback,
          mode: widget.services.mode,
        ),
      ),
    );
  }

  void _openAbout() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            AboutScreen(fares: _fares, mode: widget.services.mode),
      ),
    );
  }

  void _openSettings() => showSettingsSheet(context, widget.settings);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [context.colors.bg, context.colors.bgDeep, context.colors.bgEnd],
              stops: [0, 0.5, 1],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: ListenableBuilder(
              listenable: Listenable.merge([_fares, _controller]),
              builder: (context, _) {
                if (_fares.loadError != null) {
                  return _LoadError(onRetry: _fares.init);
                }
                if (!_fares.isReady) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildContent();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final c = _controller;
    final l10n = context.l10n;
    final message = switch (c.issue) {
      null => null,
      SearchIssue.sameStop => l10n.sameStop,
      SearchIssue.noCommonRoute => l10n.noCommonRoute(
          context.name(c.from!.nameBn, c.from!.nameEn),
          context.name(c.to!.nameBn, c.to!.nameEn)),
    };
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _Header(
            onFeedback: _openFeedback,
            onAbout: _openAbout,
            onSettings: _openSettings,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: SearchCard(
              from: c.from,
              to: c.to,
              onPickFrom: () => _pickStop(isFrom: true),
              onPickTo: () => _pickStop(isFrom: false),
              onSwap: c.swap,
            ),
          ),
        ),
        if (message != null)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(child: _MessageBanner(message)),
          )
        else if (c.results.isEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            sliver: SliverToBoxAdapter(
              child: _IdleHint(
                hint: c.from == null ? l10n.idleHintStart : l10n.idleHintTo,
                routeCount: _fares.routeCount,
                stopCount: _fares.stops.length,
                minFare: _fares.minFare,
              ),
            ),
          )
        else ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.directRoutes(
                        c.results.length, context.digits(c.results.length)),
                    style: context.text.bodyStrong,
                  ),
                  Text(l10n.resultsHint, style: context.text.caption),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemCount: c.results.length,
              itemBuilder: (context, index) => ResultCard(
                result: c.results[index],
                onTap: () => _openDetail(c.results[index]),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
          ),
        ],
        SliverToBoxAdapter(child: SizedBox(height: 32 + bottomInset)),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.onFeedback,
    required this.onAbout,
    required this.onSettings,
  });

  final VoidCallback onFeedback;
  final VoidCallback onAbout;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: AppColors.logoGradient,
                  ),
                ),
                child: const Text('🚌', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(l10n.appTitle,
                          maxLines: 1, style: context.text.display),
                    ),
                    Text(l10n.appSubtitle, style: context.text.label),
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.feedback,
                visualDensity: VisualDensity.compact,
                onPressed: onFeedback,
                icon: Icon(Icons.rate_review_outlined,
                    color: context.colors.textSecondary),
              ),
              IconButton(
                tooltip: l10n.about,
                visualDensity: VisualDensity.compact,
                onPressed: onAbout,
                icon: Icon(Icons.info_outline,
                    color: context.colors.textSecondary),
              ),
              IconButton(
                tooltip: l10n.settings,
                visualDensity: VisualDensity.compact,
                onPressed: onSettings,
                icon: Icon(Icons.settings_outlined,
                    color: context.colors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(l10n.tagline, style: context.text.caption),
        ],
      ),
    );
  }
}

class _IdleHint extends StatelessWidget {
  const _IdleHint({
    required this.hint,
    required this.routeCount,
    required this.stopCount,
    required this.minFare,
  });

  final String hint;
  final int routeCount;
  final int stopCount;
  final int minFare;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(hint, style: context.text.label),
        ),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _Stat(
                  value: l10n.countValue(context.digits(routeCount)),
                  label: l10n.statRoutes,
                ),
                const VerticalDivider(width: 1),
                _Stat(
                  value: l10n.countValue(context.digits(stopCount)),
                  label: l10n.statStops,
                ),
                const VerticalDivider(width: 1),
                _Stat(value: context.taka(minFare), label: l10n.statMinFare),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: context.text.title),
          Text(label, style: context.text.caption),
        ],
      ),
    );
  }
}

class _MessageBanner extends StatelessWidget {
  const _MessageBanner(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: context.colors.redSoft,
      borderColor: context.colors.redLine,
      radius: 14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: context.colors.red, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: context.text.body)),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.loadError,
              style: context.text.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.loadErrorHint,
              style: context.text.label,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: onRetry, child: Text(l10n.tryAgain)),
          ],
        ),
      ),
    );
  }
}
