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
    
    // ĐÂY LÀ PHIÊN BẢN ĐÃ ĐƯỢC NÂNG CẤP HOÀN CHỈNH
    GoRoute(
      path: '/player',
      builder: (context, state) {
        // 1. Lấy toàn bộ gói hàng 'extra' và ép kiểu thành Map
        final data = state.extra as Map<String, dynamic>;
        
        // 2. Lấy từng món hàng bên trong gói hàng đó
        final musicSuggestion = data['suggestion'] as Map<String, dynamic>;
        final audioUrl = data['url'] as String;
        
        // 3. Trả về PlayerPage và truyền cả hai món hàng vào đúng "hòm thư"
        return PlayerPage(
          musicSuggestion: musicSuggestion, 
          audioUrl: audioUrl,
        );
      },
    ),
    
    GoRoute(path: '/completion', builder: (context, state) => const CompletionPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
  ],
);