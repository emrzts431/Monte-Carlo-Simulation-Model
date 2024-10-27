import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/scaffold_messenger_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => ScaffoldMessengerService());
}
