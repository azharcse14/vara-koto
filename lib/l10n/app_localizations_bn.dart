// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'লোকাল বাস ভাড়া';

  @override
  String get appSubtitle => 'ঢাকার লোকাল বাসের ভাড়া খুঁজুন';

  @override
  String get tagline => 'সরকারি ভাড়া চার্ট অনুযায়ী, ডিজেল চালিত বাস';

  @override
  String get fromLabel => 'যাত্রা শুরু';

  @override
  String get toLabel => 'গন্তব্য';

  @override
  String get fromPlaceholder => 'কোথা থেকে উঠবেন?';

  @override
  String get toPlaceholder => 'কোথায় নামবেন?';

  @override
  String get swap => 'অদলবদল';

  @override
  String get feedback => 'মতামত';

  @override
  String get about => 'তথ্য';

  @override
  String get settings => 'সেটিংস';

  @override
  String get language => 'ভাষা';

  @override
  String get systemDefault => 'সিস্টেম';

  @override
  String get theme => 'থিম';

  @override
  String get light => 'লাইট';

  @override
  String get dark => 'ডার্ক';

  @override
  String get idleHintStart =>
      'কোথা থেকে উঠবেন আর কোথায় নামবেন, বেছে নিলেই সরকারি ভাড়া দেখাবে।';

  @override
  String get idleHintTo => 'এবার কোথায় নামবেন, বেছে নিন।';

  @override
  String countValue(String n) {
    return '$nটি';
  }

  @override
  String get statRoutes => 'রুট';

  @override
  String get statStops => 'স্টপ';

  @override
  String get statMinFare => 'সর্বনিম্ন ভাড়া';

  @override
  String directRoutes(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$nটি রুটে সরাসরি যাওয়া যায়',
    );
    return '$_temp0';
  }

  @override
  String get resultsHint =>
      'কম ভাড়ার রুট আগে। স্টপওয়ারি ভাড়া দেখতে রুটে ট্যাপ করুন।';

  @override
  String get sameStop => 'যাত্রার স্থান ও গন্তব্য একই হতে পারবে না।';

  @override
  String noCommonRoute(String from, String to) {
    return '“$from” ও “$to” একই রুটে পড়ে না। কাছাকাছি অন্য কোনো স্টপ বেছে দেখুন।';
  }

  @override
  String get loadError => 'ভাড়ার তথ্য লোড করা যায়নি।';

  @override
  String get loadErrorHint =>
      'অ্যাপটি বন্ধ করে আবার খুলুন, অথবা নিচের বাটনে চাপ দিন।';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String onThisRoute(String from, String to) {
    return 'এই রুটে: $from থেকে $to';
  }

  @override
  String stopCount(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$nটি স্টপ',
    );
    return '$_temp0';
  }

  @override
  String routeCount(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$nটি রুট',
    );
    return '$_temp0';
  }

  @override
  String segmentCount(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$nটি সেগমেন্ট',
    );
    return '$_temp0';
  }

  @override
  String get fare => 'ভাড়া';

  @override
  String searchHint(String label) {
    return '$label: স্টপের নাম বা রুট নম্বর';
  }

  @override
  String get clear => 'মুছে ফেলুন';

  @override
  String noStopFound(String query) {
    return '“$query” নামে কোনো স্টপ পাওয়া যায়নি';
  }

  @override
  String get noStopFoundHint =>
      'বানান একটু বদলে লিখুন, অথবা বাংলায় বা ইংরেজিতে চেষ্টা করুন। রুট নম্বর দিয়েও খোঁজা যায়, যেমন ১০১।';

  @override
  String get stopwiseTitle => 'স্টপওয়ারি ভাড়া';

  @override
  String get stopwiseSubtitle => 'যে স্টপে নামবেন, সেখান পর্যন্ত সরকারি ভাড়া';

  @override
  String get matrixTitle => 'সম্পূর্ণ ভাড়া ম্যাট্রিক্স';

  @override
  String get matrixSubtitle =>
      'এই রুটের যেকোনো দুই স্টপের ভাড়া। ডানে-বামে সরিয়ে দেখুন।';

  @override
  String get matrixCorner => 'থেকে ↓  পর্যন্ত →';

  @override
  String get totalFare => 'মোট ভাড়া';

  @override
  String routeLength(String km) {
    return 'পুরো রুট $km কিমি';
  }

  @override
  String get getOnHere => 'এখান থেকে উঠবেন';

  @override
  String fromPreviousStop(String fare) {
    return 'আগের স্টপ থেকে $fare';
  }

  @override
  String fareToHere(String n) {
    return 'এখানে নামলে ভাড়া $n টাকা';
  }

  @override
  String get feedbackTitle => 'মতামত জানান';

  @override
  String get feedbackIntro =>
      'কোনো ভাড়া ভুল দেখালে, স্টপ খুঁজে না পেলে বা নতুন কিছু চাইলে লিখে জানান।';

  @override
  String get feedbackName => 'আপনার নাম (ঐচ্ছিক)';

  @override
  String get feedbackMessage => 'আপনার মতামত বা পরামর্শ লিখুন';

  @override
  String get sending => 'পাঠানো হচ্ছে...';

  @override
  String get send => 'পাঠিয়ে দিন';

  @override
  String get feedbackFailed =>
      'মতামত পাঠানো যায়নি। ইন্টারনেট সংযোগ দেখে আবার পাঠান।';

  @override
  String get feedbackLocalNote =>
      'মতামত এখন ফোনেই জমা থাকে। অ্যাপে সার্ভার যুক্ত হলে নিজে থেকেই পাঠিয়ে দেওয়া হবে।';

  @override
  String get feedbackSent => 'মতামত পাঠানো হয়েছে। ধন্যবাদ!';

  @override
  String get feedbackSaved => 'মতামত ফোনে জমা হয়েছে। ধন্যবাদ!';

  @override
  String get feedbackSentHint => 'আপনার মতামত আমাদের কাছে পৌঁছেছে।';

  @override
  String get feedbackSavedHint =>
      'সার্ভারের সাথে সংযোগ পেলেই এটি নিজে থেকে পাঠিয়ে দেওয়া হবে।';

  @override
  String get writeAnother => 'আরেকটি মতামত লিখুন';

  @override
  String get fareSource => 'ভাড়ার তথ্যসূত্র';

  @override
  String get fareSourceBody =>
      'বিআরটিএ ডিজেল চালিত বাস ভাড়া চার্ট। সর্বনিম্ন ভাড়া ১০.০০ টাকা।';

  @override
  String get fareNotice =>
      '০৭ আশ্বিন ১৪৩৩ বঙ্গাব্দ / ২২ সেপ্টেম্বর ২০২৬\nপ্রজ্ঞাপন নং-৩৫.০০.০০০০.০২০.২৬.০০৫.১৬-৫৪০';

  @override
  String dataVersion(String version) {
    return 'ডেটা সংস্করণ: $version';
  }

  @override
  String get dataLocal => 'সব তথ্য অ্যাপের ভেতরেই আছে, ইন্টারনেট ছাড়াও চলে।';

  @override
  String get dataRemote =>
      'তথ্য সার্ভার থেকে হালনাগাদ হয়, ইন্টারনেট না থাকলে শেষ সংরক্ষিত তথ্য দেখায়।';
}
