import 'package:go_router/go_router.dart';
import 'package:melodi_ai/pages/completion_page.dart';
import 'package:melodi_ai/pages/emotion_input_page.dart';
import 'package:melodi_ai/pages/player_page.dart';
import 'package:melodi_ai/pages/login_page.dart';
import 'package:melodi_ai/pages/signup_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const EmotionInputPage()),
    
    // ĐÂY LÀ PHIÊN BẢN ĐÃ ĐƯỢC NÂNG CẤP
    GoRoute(
      path: '/player',
      builder: (context, state) {
        // Lấy "gói hàng" được gửi qua tham số 'extra'
        // Chúng ta ép kiểu nó thành Map<String, dynamic> để Dart hiểu
        final musicSuggestion = state.extra as Map<String, dynamic>;
        
        // Trả về PlayerPage và truyền "gói hàng" vào "hòm thư" musicSuggestion
        return PlayerPage(musicSuggestion: musicSuggestion);
      },
    ),
    
    GoRoute(path: '/completion', builder: (context, state) => const CompletionPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
  ],
);
