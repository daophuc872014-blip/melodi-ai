import 'package:flutter/material.dart';
import 'package:melodi_ai/routes/app_router.dart';

void main() {
  // Không cần load file .env nữa, ứng dụng khởi động ngay lập tức!
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'Melody.AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F3057),
        primarySwatch: Colors.blue,
      ),
    );
  }
} 