import 'package:flutter/material.dart';

import '../../config/app_config.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('মতামত জানান / Feedback')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: outcome != null
            ? [_Done(outcome: outcome, onWriteAnother: () => setState(() => _outcome = null))]
            : [
                const Text(
                  'কোনো ভাড়া ভুল দেখালে, স্টপ খুঁজে না পেলে বা নতুন কিছু চাইলে লিখে জানান।',
                  style: AppText.label,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  style: AppText.body,
                  decoration:
                      appInputDecoration('আপনার নাম (ঐচ্ছিক) / Name (optional)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _message,
                  minLines: 4,
                  maxLines: 8,
                  maxLength: 2000,
                  onChanged: (_) => setState(() {}),
                  style: AppText.body,
                  decoration: appInputDecoration(
                      'আপনার মতামত বা পরামর্শ লিখুন / Write your feedback'),
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
                  child: Text(_submitting ? 'পাঠানো হচ্ছে...' : 'পাঠিয়ে দিন / Send'),
                ),
                if (_failed)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      'মতামত পাঠানো যায়নি। ইন্টারনেট সংযোগ দেখে আবার পাঠান।',
                      style: TextStyle(color: AppColors.red),
                    ),
                  ),
                if (widget.mode == DataMode.local)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'মতামত এখন ফোনেই জমা থাকে। অ্যাপে সার্ভার যুক্ত হলে নিজে থেকেই পাঠিয়ে দেওয়া হবে।',
                      style: AppText.caption,
                    ),
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
    return AppCard(
      padding: const EdgeInsets.all(20),
      borderColor: const Color(0x4D22D3A5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.green, size: 32),
          const SizedBox(height: 12),
          Text(
            sent ? 'মতামত পাঠানো হয়েছে। ধন্যবাদ!' : 'মতামত ফোনে জমা হয়েছে। ধন্যবাদ!',
            style: AppText.title,
          ),
          const SizedBox(height: 6),
          Text(
            sent
                ? 'আপনার মতামত আমাদের কাছে পৌঁছেছে।'
                : 'সার্ভারের সাথে সংযোগ পেলেই এটি নিজে থেকে পাঠিয়ে দেওয়া হবে।',
            style: AppText.label,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onWriteAnother,
            child: const Text('আরেকটি মতামত লিখুন'),
          ),
        ],
      ),
    );
  }
}
