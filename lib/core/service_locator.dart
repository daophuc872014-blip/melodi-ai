import 'package:get_it/get_it.dart';
import 'package:melodi_ai/services/ai_service.dart';
import 'package:melodi_ai/services/mock_music_generation_service.dart';

// Tạo ra một thực thể (instance) duy nhất của "Người quản lý" GetIt.
final locator = GetIt.instance;

/// Hàm này chịu trách nhiệm "đăng ký" tất cả các service của chúng ta.
void setupLocator() {
  // Đăng ký AIService.
  // LazySingleton: Chỉ tạo ra AIService ở lần đầu tiên nó được yêu cầu.
  locator.registerLazySingleton(() => AIService());

  // Đăng ký MockMusicGenerationService.
  locator.registerLazySingleton(() => MockMusicGenerationService());
}
