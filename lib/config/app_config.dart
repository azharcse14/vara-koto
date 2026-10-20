/// Where the app gets its data from.
///
/// [DataMode.local] (default): fares ship inside the app and work offline.
/// Feedback is kept on the phone until a server is available.
///
/// [DataMode.remote]: fares are synced from your server and cached on the
/// phone, with the bundled copy as a fallback. Feedback is posted to the
/// server's existing /api/feedback endpoint.
///
/// Switch without touching code:
///   flutter run --dart-define=DATA_MODE=remote --dart-define=API_BASE=https://your-server.com/api
enum DataMode { local, remote }

class AppConfig {
  const AppConfig._();

  static const String _mode =
      String.fromEnvironment('DATA_MODE', defaultValue: 'local');

  /// Base URL of the Express API, without a trailing slash.
  /// 10.0.2.2 is how the Android emulator reaches localhost on your computer.
  static const String apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://10.0.2.2:5000/api',
  );

  static DataMode get mode =>
      _mode == 'remote' ? DataMode.remote : DataMode.local;
}
