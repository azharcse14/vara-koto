import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../data/models/stop_entry.dart';
import '../../../widgets/common.dart';

const double _fieldHeight = 76;
const double _dotSize = 14;
const double _leftInset = 16;
const double _rightInset = 76; // room for the swap button

/// From / To picker. The two dots and the line between them read as one
/// journey, the way ride apps show it.
class SearchCard extends StatelessWidget {
  const SearchCard({
    super.key,
    required this.from,
    required this.to,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onSwap,
  });

  final StopEntry? from;
  final StopEntry? to;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    const dotCenter = _fieldHeight / 2;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Column(
            children: [
              _StopField(
                label: 'যাত্রা শুরু',
                labelEn: 'From',
                dotColor: AppColors.green,
                stop: from,
                placeholder: 'কোথা থেকে উঠবেন?',
                onTap: onPickFrom,
              ),
              const Divider(
                height: 1,
                indent: _leftInset + _dotSize + 16,
                endIndent: _rightInset,
              ),
              _StopField(
                label: 'গন্তব্য',
                labelEn: 'To',
                dotColor: AppColors.red,
                stop: to,
                placeholder: 'কোথায় নামবেন?',
                onTap: onPickTo,
              ),
            ],
          ),
          // Line joining the two dots.
          const Positioned(
            left: _leftInset + _dotSize / 2 - 1,
            top: dotCenter + _dotSize / 2 + 3,
            height: _fieldHeight + 1 - _dotSize - 6,
            child: IgnorePointer(
              child: SizedBox(
                width: 2,
                child: ColoredBox(color: Color(0x26FFFFFF)),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(child: _SwapButton(onPressed: onSwap)),
          ),
        ],
      ),
    );
  }
}

class _StopField extends StatelessWidget {
  const _StopField({
    required this.label,
    required this.labelEn,
    required this.dotColor,
    required this.stop,
    required this.placeholder,
    required this.onTap,
  });

  final String label;
  final String labelEn;
  final Color dotColor;
  final StopEntry? stop;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = stop;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: _fieldHeight,
        child: Padding(
          padding: const EdgeInsets.only(left: _leftInset, right: _rightInset),
          child: Row(
            children: [
              Container(
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.bg,
                  border: Border.all(color: dotColor, width: 3.5),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$label / $labelEn', style: AppText.caption),
                    if (selected == null)
                      Text(
                        placeholder,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodyStrong
                            .copyWith(color: AppColors.textMuted),
                      )
                    else
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text: selected.nameBn, style: AppText.bodyStrong),
                          TextSpan(
                              text: '  ${selected.nameEn}',
                              style: AppText.label),
                        ]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwapButton extends StatefulWidget {
  const _SwapButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_SwapButton> createState() => _SwapButtonState();
}

class _SwapButtonState extends State<_SwapButton> {
  double _turns = 0;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return Tooltip(
      message: 'অদলবদল / Swap',
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(side: BorderSide(color: AppColors.amberLine)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            setState(() => _turns += 0.5);
            widget.onPressed();
          },
          child: SizedBox(
            width: 44,
            height: 44,
            child: AnimatedRotation(
              turns: _turns,
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: const Icon(Icons.swap_vert, color: AppColors.amber),
            ),
          ),
        ),
      ),
    );
  }
}
