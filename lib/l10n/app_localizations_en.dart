// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Local Bus Fare';

  @override
  String get appSubtitle => 'Dhaka local bus fare finder';

  @override
  String get tagline => 'Official fare chart, diesel buses';

  @override
  String get fromLabel => 'From';

  @override
  String get toLabel => 'To';

  @override
  String get fromPlaceholder => 'Where are you getting on?';

  @override
  String get toPlaceholder => 'Where are you getting off?';

  @override
  String get swap => 'Swap';

  @override
  String get feedback => 'Feedback';

  @override
  String get about => 'About';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get idleHintStart =>
      'Pick where you get on and where you get off to see the official fare.';

  @override
  String get idleHintTo => 'Now pick where you get off.';

  @override
  String countValue(String n) {
    return '$n';
  }

  @override
  String get statRoutes => 'Routes';

  @override
  String get statStops => 'Stops';

  @override
  String get statMinFare => 'Minimum fare';

  @override
  String directRoutes(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n routes go there directly',
      one: '$n route goes there directly',
    );
    return '$_temp0';
  }

  @override
  String get resultsHint => 'Tap a route for stop-by-stop fares.';

  @override
  String get sameStop => 'Start and destination can\'t be the same.';

  @override
  String noCommonRoute(String from, String to) {
    return 'No single route goes from “$from” to “$to”. Try a nearby stop.';
  }

  @override
  String get loadError => 'Couldn\'t load fare data.';

  @override
  String get loadErrorHint =>
      'Close and reopen the app, or tap the button below.';

  @override
  String get tryAgain => 'Try again';

  @override
  String busRoute(String name) {
    return 'Bus route: $name';
  }

  @override
  String stopCount(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n stops',
      one: '$n stop',
    );
    return '$_temp0';
  }

  @override
  String routeCount(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n routes',
      one: '$n route',
    );
    return '$_temp0';
  }

  @override
  String segmentCount(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n segments',
      one: '$n segment',
    );
    return '$_temp0';
  }

  @override
  String get fare => 'Fare';

  @override
  String searchHint(String label) {
    return '$label: stop name or route number';
  }

  @override
  String get clear => 'Clear';

  @override
  String noStopFound(String query) {
    return 'No stop found for “$query”';
  }

  @override
  String get noStopFoundHint =>
      'Try a different spelling, or search in Bangla or English. You can also search by route number, like 101.';

  @override
  String get stopwiseTitle => 'Stop-by-stop fare';

  @override
  String get stopwiseSubtitle => 'Official fare to the stop where you get off';

  @override
  String get matrixTitle => 'Full fare matrix';

  @override
  String get matrixSubtitle =>
      'Fare between any two stops on this route. Scroll sideways to see more.';

  @override
  String get matrixCorner => 'From ↓  To →';

  @override
  String get totalFare => 'Total fare';

  @override
  String routeLength(String km) {
    return 'Full route $km km';
  }

  @override
  String get getOnHere => 'Get on here';

  @override
  String fromPreviousStop(String fare) {
    return '$fare from the previous stop';
  }

  @override
  String fareToHere(String n) {
    return 'Fare to get off here: $n taka';
  }

  @override
  String get feedbackTitle => 'Send feedback';

  @override
  String get feedbackIntro =>
      'Tell us if a fare looks wrong, a stop is missing, or you\'d like something new.';

  @override
  String get feedbackName => 'Your name (optional)';

  @override
  String get feedbackMessage => 'Write your feedback or suggestion';

  @override
  String get sending => 'Sending...';

  @override
  String get send => 'Send';

  @override
  String get feedbackFailed =>
      'Couldn\'t send feedback. Check your internet connection and try again.';

  @override
  String get feedbackLocalNote =>
      'Feedback is saved on your phone for now. It will be sent automatically once the app is connected to a server.';

  @override
  String get feedbackSent => 'Feedback sent. Thank you!';

  @override
  String get feedbackSaved => 'Feedback saved on your phone. Thank you!';

  @override
  String get feedbackSentHint => 'Your feedback has reached us.';

  @override
  String get feedbackSavedHint =>
      'It will be sent automatically once the server can be reached.';

  @override
  String get writeAnother => 'Write another';

  @override
  String get fareSource => 'Fare source';

  @override
  String get fareSourceBody =>
      'BRTA fare chart for diesel buses. Minimum fare 10.00 taka.';

  @override
  String get fareNotice =>
      '22 September 2026\nNotification no. 35.00.0000.020.26.005.16-540';

  @override
  String dataUpdated(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Data last updated: $dateString';
  }

  @override
  String get dataLocal =>
      'All data is inside the app, so it works without internet.';

  @override
  String get dataRemote =>
      'Data updates from the server. Without internet, the last saved data is shown.';

  @override
  String get busesTitle => 'Buses on this road';

  @override
  String get busesSubtitle =>
      'Not from BRTA. Collected from public sources, so it may be out of date.';

  @override
  String busesNote(String from, String to, String route) {
    return 'Our list shows these buses running from $from to $to along route $route\'s road, so the fare above should apply. The list is unofficial, so ask the conductor before you get on.';
  }

  @override
  String get busesNone =>
      'We don\'t know which buses run this road yet. Please check at the bus stop.';

  @override
  String get busSource => 'Bus names';

  @override
  String get busSourceBody =>
      'Unofficial list, not from BRTA. From the “Dhaka Local Bus Route” dataset by Mahabub Hasan Mamun (Kaggle), CDLA-Sharing 1.0. Buses and stops may have changed.';
}
