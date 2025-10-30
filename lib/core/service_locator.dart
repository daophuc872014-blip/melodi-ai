import 'package:get_it/get_it.dart';
import 'package:melodi_ai/services/ai_service.dart';
import 'package:melodi_ai/services/music_generation_service.dart'; // Đảm bảo đã import

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AIService());

  // Đăng ký MusicGenerationService mới mà không cần truyền key nào
  locator.registerLazySingleton(() => MusicGenerationService());
}