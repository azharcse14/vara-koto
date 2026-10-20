import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Local Bus Fare'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dhaka local bus fare finder'**
  String get appSubtitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Official fare chart, diesel buses'**
  String get tagline;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromLabel;

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toLabel;

  /// No description provided for @fromPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Where are you getting on?'**
  String get fromPlaceholder;

  /// No description provided for @toPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Where are you getting off?'**
  String get toPlaceholder;

  /// No description provided for @swap.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get swap;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemDefault;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @idleHintStart.
  ///
  /// In en, this message translates to:
  /// **'Pick where you get on and where you get off to see the official fare.'**
  String get idleHintStart;

  /// No description provided for @idleHintTo.
  ///
  /// In en, this message translates to:
  /// **'Now pick where you get off.'**
  String get idleHintTo;

  /// A count on the home screen stats, e.g. 120 routes.
  ///
  /// In en, this message translates to:
  /// **'{n}'**
  String countValue(String n);

  /// No description provided for @statRoutes.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get statRoutes;

  /// No description provided for @statStops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get statStops;

  /// No description provided for @statMinFare.
  ///
  /// In en, this message translates to:
  /// **'Minimum fare'**
  String get statMinFare;

  /// count picks the plural form; n is the same number, written in the app's digits.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{n} route goes there directly} other{{n} routes go there directly}}'**
  String directRoutes(int count, String n);

  /// No description provided for @resultsHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a route for stop-by-stop fares.'**
  String get resultsHint;

  /// No description provided for @sameStop.
  ///
  /// In en, this message translates to:
  /// **'Start and destination can\'t be the same.'**
  String get sameStop;

  /// No description provided for @noCommonRoute.
  ///
  /// In en, this message translates to:
  /// **'No single route goes from “{from}” to “{to}”. Try a nearby stop.'**
  String noCommonRoute(String from, String to);

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load fare data.'**
  String get loadError;

  /// No description provided for @loadErrorHint.
  ///
  /// In en, this message translates to:
  /// **'Close and reopen the app, or tap the button below.'**
  String get loadErrorHint;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @busRoute.
  ///
  /// In en, this message translates to:
  /// **'Bus route: {name}'**
  String busRoute(String name);

  /// No description provided for @stopCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{n} stop} other{{n} stops}}'**
  String stopCount(int count, String n);

  /// No description provided for @routeCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{n} route} other{{n} routes}}'**
  String routeCount(int count, String n);

  /// No description provided for @segmentCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{n} segment} other{{n} segments}}'**
  String segmentCount(int count, String n);

  /// No description provided for @fare.
  ///
  /// In en, this message translates to:
  /// **'Fare'**
  String get fare;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'{label}: stop name or route number'**
  String searchHint(String label);

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noStopFound.
  ///
  /// In en, this message translates to:
  /// **'No stop found for “{query}”'**
  String noStopFound(String query);

  /// No description provided for @noStopFoundHint.
  ///
  /// In en, this message translates to:
  /// **'Try a different spelling, or search in Bangla or English. You can also search by route number, like 101.'**
  String get noStopFoundHint;

  /// No description provided for @stopwiseTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop-by-stop fare'**
  String get stopwiseTitle;

  /// No description provided for @stopwiseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Official fare to the stop where you get off'**
  String get stopwiseSubtitle;

  /// No description provided for @matrixTitle.
  ///
  /// In en, this message translates to:
  /// **'Full fare matrix'**
  String get matrixTitle;

  /// No description provided for @matrixSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fare between any two stops on this route. Scroll sideways to see more.'**
  String get matrixSubtitle;

  /// No description provided for @matrixCorner.
  ///
  /// In en, this message translates to:
  /// **'From ↓  To →'**
  String get matrixCorner;

  /// No description provided for @totalFare.
  ///
  /// In en, this message translates to:
  /// **'Total fare'**
  String get totalFare;

  /// No description provided for @routeLength.
  ///
  /// In en, this message translates to:
  /// **'Full route {km} km'**
  String routeLength(String km);

  /// No description provided for @getOnHere.
  ///
  /// In en, this message translates to:
  /// **'Get on here'**
  String get getOnHere;

  /// No description provided for @fromPreviousStop.
  ///
  /// In en, this message translates to:
  /// **'{fare} from the previous stop'**
  String fromPreviousStop(String fare);

  /// No description provided for @fareToHere.
  ///
  /// In en, this message translates to:
  /// **'Fare to get off here: {n} taka'**
  String fareToHere(String n);

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackIntro.
  ///
  /// In en, this message translates to:
  /// **'Tell us if a fare looks wrong, a stop is missing, or you\'d like something new.'**
  String get feedbackIntro;

  /// No description provided for @feedbackName.
  ///
  /// In en, this message translates to:
  /// **'Your name (optional)'**
  String get feedbackName;

  /// No description provided for @feedbackMessage.
  ///
  /// In en, this message translates to:
  /// **'Write your feedback or suggestion'**
  String get feedbackMessage;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @feedbackFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send feedback. Check your internet connection and try again.'**
  String get feedbackFailed;

  /// No description provided for @feedbackLocalNote.
  ///
  /// In en, this message translates to:
  /// **'Feedback is saved on your phone for now. It will be sent automatically once the app is connected to a server.'**
  String get feedbackLocalNote;

  /// No description provided for @feedbackSent.
  ///
  /// In en, this message translates to:
  /// **'Feedback sent. Thank you!'**
  String get feedbackSent;

  /// No description provided for @feedbackSaved.
  ///
  /// In en, this message translates to:
  /// **'Feedback saved on your phone. Thank you!'**
  String get feedbackSaved;

  /// No description provided for @feedbackSentHint.
  ///
  /// In en, this message translates to:
  /// **'Your feedback has reached us.'**
  String get feedbackSentHint;

  /// No description provided for @feedbackSavedHint.
  ///
  /// In en, this message translates to:
  /// **'It will be sent automatically once the server can be reached.'**
  String get feedbackSavedHint;

  /// No description provided for @writeAnother.
  ///
  /// In en, this message translates to:
  /// **'Write another'**
  String get writeAnother;

  /// No description provided for @fareSource.
  ///
  /// In en, this message translates to:
  /// **'Fare source'**
  String get fareSource;

  /// No description provided for @fareSourceBody.
  ///
  /// In en, this message translates to:
  /// **'BRTA fare chart for diesel buses. Minimum fare 10.00 taka.'**
  String get fareSourceBody;

  /// No description provided for @fareNotice.
  ///
  /// In en, this message translates to:
  /// **'22 September 2026\nNotification no. 35.00.0000.020.26.005.16-540'**
  String get fareNotice;

  /// No description provided for @dataUpdated.
  ///
  /// In en, this message translates to:
  /// **'Data last updated: {date}'**
  String dataUpdated(DateTime date);

  /// No description provided for @dataLocal.
  ///
  /// In en, this message translates to:
  /// **'All data is inside the app, so it works without internet.'**
  String get dataLocal;

  /// No description provided for @dataRemote.
  ///
  /// In en, this message translates to:
  /// **'Data updates from the server. Without internet, the last saved data is shown.'**
  String get dataRemote;

  /// No description provided for @busesTitle.
  ///
  /// In en, this message translates to:
  /// **'Buses on this road'**
  String get busesTitle;

  /// No description provided for @busesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Not from BRTA. Collected from public sources, so it may be out of date.'**
  String get busesSubtitle;

  /// No description provided for @busesNote.
  ///
  /// In en, this message translates to:
  /// **'Our list shows these buses running from {from} to {to} along route {route}\'s road, so the fare above should apply. The list is unofficial, so ask the conductor before you get on.'**
  String busesNote(String from, String to, String route);

  /// No description provided for @busesNone.
  ///
  /// In en, this message translates to:
  /// **'We don\'t know which buses run this road yet. Please check at the bus stop.'**
  String get busesNone;

  /// No description provided for @busSource.
  ///
  /// In en, this message translates to:
  /// **'Bus names'**
  String get busSource;

  /// No description provided for @busSourceBody.
  ///
  /// In en, this message translates to:
  /// **'Unofficial list, not from BRTA. From the “Dhaka Local Bus Route” dataset by Mahabub Hasan Mamun (Kaggle), CDLA-Sharing 1.0. Buses and stops may have changed.'**
  String get busSourceBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
