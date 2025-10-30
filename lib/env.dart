import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GEMINI_API_KEY')
  static const String geminiApiKey = _Env.geminiApiKey;

  // BẢN NÂNG CẤP: Đổi sunoApiKey thành musicApiKey để khớp với nhà máy Google
  @EnviedField(varName: 'MUSIC_API_KEY')
  static const String musicApiKey = _Env.musicApiKey;
}