import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/feedback_repository.dart';
import '../../widgets/common.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key, required this.repository, required this.mode});

  final FeedbackRepository repository;
  final DataMode mode;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _name = TextEditingController();
  final _message = TextEditingController();
  bool _submitting = false;
  bool _failed = false;
  FeedbackOutcome? _outcome;

  @override
  void dispose() {
    _name.dispose();
    _message.dispose();
    super.dispose();
  }

  bool get _canSubmit => !_submitting && _message.text.trim().isNotEmpty;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _failed = false;
    });
    try {
      final outcome = await widget.repository
          .submit(name: _name.text, message: _message.text);
      if (!mounted) return;
      setState(() => _outcome = outcome);
      _name.clear();
      _message.clear();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final outcome = _outcome;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.feedbackTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: outcome != null
            ? [_Done(outcome: outcome, onWriteAnother: () => setState(() => _outcome = null))]
            : [
                Text(l10n.feedbackIntro, style: context.text.label),
                const SizedBox(height: 16),
                TextField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  style: context.text.body,
                  decoration: appInputDecoration(context, l10n.feedbackName),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _message,
                  minLines: 4,
                  maxLines: 8,
                  maxLength: 2000,
                  onChanged: (_) => setState(() {}),
                  style: context.text.body,
                  decoration: appInputDecoration(context, l10n.feedbackMessage),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _canSubmit ? _submit : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Text(_submitting ? l10n.sending : l10n.send),
                ),
                if (_failed)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      l10n.feedbackFailed,
                      style: TextStyle(color: context.colors.red),
                    ),
                  ),
                if (widget.mode == DataMode.local)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(l10n.feedbackLocalNote, style: context.text.caption),
                  ),
              ],
      ),
    );
  }
}

class _Done extends StatelessWidget {
  const _Done({required this.outcome, required this.onWriteAnother});

  final FeedbackOutcome outcome;
  final VoidCallback onWriteAnother;

  @override
  Widget build(BuildContext context) {
    final sent = outcome == FeedbackOutcome.sent;
    final l10n = context.l10n;
    return AppCard(
      padding: const EdgeInsets.all(20),
      borderColor: context.colors.greenLine,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: context.colors.green, size: 32),
          const SizedBox(height: 12),
          Text(
            sent ? l10n.feedbackSent : l10n.feedbackSaved,
            style: context.text.title,
          ),
          const SizedBox(height: 6),
          Text(
            sent ? l10n.feedbackSentHint : l10n.feedbackSavedHint,
            style: context.text.label,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onWriteAnother,
            child: Text(l10n.writeAnother),
          ),
        ],
      ),
    );
  }
}
