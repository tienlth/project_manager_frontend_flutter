import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;

void regisDioLocator() {
  getIt.registerLazySingleton<DioClient>(() => DioClient());
}
