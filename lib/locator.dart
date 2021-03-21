import 'package:get_it/get_it.dart';
import 'package:live_tv/analytics_service.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton(() => AnalyticsService());
}
