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
    GoRoute(path: '/player', builder: (context, state) => const PlayerPage()),
    GoRoute(path: '/completion', builder: (context, state) => const CompletionPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
  ],
);