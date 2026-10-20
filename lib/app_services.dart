import 'package:http/http.dart' as http;

import 'config/app_config.dart';
import 'data/fare_repository.dart';
import 'data/feedback_repository.dart';
import 'data/sources/remote_route_source.dart';
import 'data/sources/route_data_source.dart';

/// The single place that decides local vs server. Screens receive these
/// objects and never know which mode is active.
class AppServices {
  AppServices({
    required this.fares,
    required this.feedback,
    required this.mode,
  });

  factory AppServices.fromConfig() => switch (AppConfig.mode) {
        DataMode.local => AppServices.local(),
        DataMode.remote => AppServices.remote(AppConfig.apiBase),
      };

  /// Everything on the phone. Works offline.
  factory AppServices.local() => AppServices(
        mode: DataMode.local,
        fares: FareRepository(const AssetRouteDataSource()),
        feedback: LocalFeedbackRepository(FeedbackOutbox()),
      );

  /// Fares synced from the server (bundled copy as fallback),
  /// feedback posted to the server.
  factory AppServices.remote(String apiBase) {
    final client = http.Client();
    return AppServices(
      mode: DataMode.remote,
      fares: FareRepository(
        RemoteRouteDataSource(baseUrl: apiBase, client: client),
      ),
      feedback: RemoteFeedbackRepository(
        baseUrl: apiBase,
        outbox: FeedbackOutbox(),
        client: client,
      ),
    );
  }

  final FareRepository fares;
  final FeedbackRepository feedback;
  final DataMode mode;
}
