import 'package:go_router/go_router.dart';
import 'package:melodi_ai/pages/completion_page.dart';
import 'package:melodi_ai/pages/emotion_input_page.dart';
import 'package:melodi_ai/pages/player_page.dart';

// Cấu hình "bản đồ" cho ứng dụng
final GoRouter appRouter = GoRouter(
  // initialLocation là địa chỉ bắt đầu khi mở ứng dụng
  initialLocation: '/',
  // routes là danh sách tất cả các "địa chỉ" và "địa điểm"
  routes: [
    // Địa chỉ gốc của ứng dụng
    GoRoute(
      path: '/',
      builder: (context, state) => const EmotionInputPage(),
    ),
    // Địa chỉ của màn hình Player
    GoRoute(
      path: '/player',
      builder: (context, state) => const PlayerPage(),
    ),
    // Địa chỉ của màn hình Completion
    GoRoute(
      path: '/completion',
      builder: (context, state) => const CompletionPage(),
    ),
  ],
);
