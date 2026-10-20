# ভাড়া কত? (Bhara Koto?)

**Dhaka local bus fares, straight from the government chart.**

Pick where you get on and where you get off. Bhara Koto? shows the official BRTA fare on every route that connects the two stops, stop by stop, even without internet.

ঢাকার লোকাল বাসে কোথা থেকে উঠবেন আর কোথায় নামবেন বেছে নিন, সরকারি চার্ট অনুযায়ী ভাড়া দেখে নিন। ইন্টারনেট ছাড়াও চলে।

![Flutter](https://img.shields.io/badge/Flutter-Android%20%7C%20iOS-02569B?logo=flutter)
![Offline](https://img.shields.io/badge/works-offline-22d3a5)
![Routes](https://img.shields.io/badge/routes-120-fbbc24)

<!-- Add screenshots here: home, stop search, route detail -->

## Why

Bus fares in Dhaka get argued over every day, and the official BRTA chart is a long table that nobody carries around. Bhara Koto? puts that chart in your pocket, so you know the right fare before you pay.

## Features

- **Official fare for any two stops** across 120 route numbers and 371 stops.
- **Search the way you type.** Bangla or English, either digit style ("mirpur ১০", "মিরপুর-10"), or a route number (১০১, A-101).
- **Every route that connects your stops**, cheapest first.
- **Stop-by-stop fares.** See what you'd pay if you got off at each stop on the way.
- **Full fare matrix** for each route, with your two stops highlighted.
- **Works offline.** All fare data ships inside the app, and lookups run on the phone.
- **Ready for a server.** Fares can later sync from a server without an app update.
- **Feedback form** for reporting wrong fares or missing stops.

## Fare data

Source: BRTA diesel-powered bus fare chart, notice no. ৩৫.০০.০০০০.০২০.২৬.০০৫.১৬-৫৪০, dated ০৭ আশ্বিন ১৪৩৩ / ২২ সেপ্টেম্বর ২০২৬. Minimum fare ৳10.

Found a wrong fare or a missing stop? [Open an issue](../../issues) with the route number and both stop names, or use the feedback form in the app.

## Getting started

Requires [Flutter](https://docs.flutter.dev/get-started/install) 3.24 or newer.

```bash
git clone https://github.com/abrarjahinzihan/bhara-koto.git
cd bhara-koto
flutter create --project-name dhaka_bus_vara --org com.abrarjahin --platforms=android,ios .
flutter pub get
flutter test
flutter run
```

The repo holds the app code only. `flutter create .` generates the Android and iOS project files once; it doesn't overwrite existing files.

**Before publishing**, set the app name and ID. These can't be changed after the first Play Store release.

- Android, in `android/app/src/main/AndroidManifest.xml`: `android:label="ভাড়া কত?"`.
- Android, in `android/app/build.gradle.kts` (or `build.gradle` on older Flutter): `applicationId = "com.abrarjahin.bharakoto"`.
- iOS, in `ios/Runner/Info.plist`: set `CFBundleDisplayName`, and set the bundle identifier in Xcode.

## How it works

All fare lookups happen on the phone, in every mode. The app only needs the data file, which comes from one of two sources behind a single interface:

| Mode | Fare data | Feedback |
| --- | --- | --- |
| `local` (default) | `assets/data/routes.json`, bundled in the app | Saved on the phone until a server is available |
| `remote` | `GET /api/routes`, cached on the phone; bundled copy as fallback | `POST /api/feedback`; saved on the phone if offline, retried on next launch |

Switch modes at build time, with no code changes:

```bash
flutter build apk --dart-define=DATA_MODE=remote --dart-define=API_BASE=https://your-server.com/api
```

The mode is chosen in one place, `lib/app_services.dart`. The screens never know which mode is active.

## Updating fares

1. Edit `fareData.js`.
2. Rebuild the asset, using the new chart's date as the version:
   ```bash
   node tool/export_data.js path/to/fareData.js 2026-12-01
   ```
3. Ship the update:
   - **Local mode:** publish an app update.
   - **Server mode:** replace `routes.json` on the server. Apps load it on their next launch.

The stop list is built from `routes.json` at start-up, so there's only one file to keep up to date.

## Project layout

```
lib/
  app_services.dart        picks local or server mode
  config/                  DATA_MODE and API_BASE
  core/                    theme, Bangla digit helpers
  data/                    models, data sources, repositories
  domain/                  stop index, stop search, fare finder (pure Dart)
  features/                home, stop picker, route detail, feedback, about
assets/
  data/routes.json         124 route entries with fare matrices
  fonts/                   Hind Siliguri, bundled so Bangla renders offline
tool/
  export_data.js           fareData.js → routes.json
  find_spelling_variants.js lists stops spelled two ways in the data
test/                      logic tests against the real data
```

## Accuracy notes

**Exact stop matching.** A stop is matched by its exact name, or by an exact alias. It is never matched on part of a name, so "Mirpur-1" can't turn into "Mirpur-12" on a route that doesn't serve Mirpur-1.

**Spelling variants.** Some places are spelled differently on different routes, such as Palton/Paltan or Asadgate/Asad Gate. When a route uses another spelling, the result shows that route's own stop names, so you know where to board. Aliases don't link every variant yet; `node tool/find_spelling_variants.js` lists them. Using one English name per stop in the data fixes this.

**Duplicates.** Routes listed twice in the source data are shown once.

## Web version

[dhakalocalbusvara.vercel.app](https://dhakalocalbusvara.vercel.app/), built with React and Express ([repo](https://github.com/abrarjahinzihan/DHAKA_LOCAL_BUS_VARA)).

## Credits

Created by **Abrar Jahin Zihan**:

- [GitHub](https://github.com/abrarjahinzihan)
- [Facebook](https://www.facebook.com/abrarjahinzihan/)
- [LinkedIn](https://www.linkedin.com/in/abrar-jahin-zihan-b8b250328)
- [Email](mailto:abrarjahinkhanzihan@gmail.com)

Hind Siliguri font © Indian Type Foundry, used under the SIL Open Font License (`assets/fonts/OFL.txt`).
