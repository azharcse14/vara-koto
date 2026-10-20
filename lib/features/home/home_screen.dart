import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_services.dart';
import '../../core/bangla_text.dart';
import '../../core/theme.dart';
import '../../data/fare_repository.dart';
import '../../data/models/fare_result.dart';
import '../../data/models/stop_entry.dart';
import '../../widgets/common.dart';
import '../about/about_screen.dart';
import '../feedback/feedback_screen.dart';
import '../route_detail/route_detail_screen.dart';
import '../stop_picker/stop_picker_screen.dart';
import 'home_controller.dart';
import 'widgets/result_card.dart';
import 'widgets/search_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.services});

  final AppServices services;

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
          label: isFrom ? 'যাত্রা শুরু' : 'গন্তব্য',
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.bg, AppColors.bgDeep, AppColors.bgEnd],
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
    final message = c.message;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _Header(onFeedback: _openFeedback, onAbout: _openAbout),
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
                hint: c.from == null
                    ? 'কোথা থেকে উঠবেন আর কোথায় নামবেন, বেছে নিলেই সরকারি ভাড়া দেখাবে।'
                    : 'এবার কোথায় নামবেন, বেছে নিন।',
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
                    '${toBnDigits(c.results.length)}টি রুটে সরাসরি যাওয়া যায়',
                    style: AppText.bodyStrong,
                  ),
                  const Text(
                    'কম ভাড়ার রুট আগে। স্টপওয়ারি ভাড়া দেখতে রুটে ট্যাপ করুন।',
                    style: AppText.caption,
                  ),
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
                chosenFrom: c.from!.nameEn,
                chosenTo: c.to!.nameEn,
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
  const _Header({required this.onFeedback, required this.onAbout});

  final VoidCallback onFeedback;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
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
                    colors: [AppColors.amber, AppColors.orange],
                  ),
                ),
                child: const Text('🚌', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('লোকাল বাস ভাড়া', style: AppText.display),
                    Text('Dhaka Local Bus Fare Finder', style: AppText.label),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'মতামত / Feedback',
                onPressed: onFeedback,
                icon: const Icon(Icons.rate_review_outlined,
                    color: AppColors.textSecondary),
              ),
              IconButton(
                tooltip: 'তথ্য / About',
                onPressed: onAbout,
                icon: const Icon(Icons.info_outline,
                    color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'সরকারি ভাড়া চার্ট অনুযায়ী, ডিজেল চালিত বাস',
            style: AppText.caption,
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(hint, style: AppText.label),
        ),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _Stat(value: '${toBnDigits(routeCount)}টি', label: 'রুট'),
                const VerticalDivider(width: 1),
                _Stat(value: '${toBnDigits(stopCount)}টি', label: 'স্টপ'),
                const VerticalDivider(width: 1),
                _Stat(value: taka(minFare), label: 'সর্বনিম্ন ভাড়া'),
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
          Text(value, style: AppText.title),
          Text(label, style: AppText.caption),
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
      color: AppColors.redSoft,
      borderColor: const Color(0x4DF87171),
      radius: 14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.red, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: AppText.body)),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ভাড়ার তথ্য লোড করা যায়নি।',
              style: AppText.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'অ্যাপটি বন্ধ করে আবার খুলুন, অথবা নিচের বাটনে চাপ দিন।',
              style: AppText.label,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onRetry,
              child: const Text('আবার চেষ্টা করুন'),
            ),
          ],
        ),
      ),
    );
  }
}
