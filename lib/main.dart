import 'package:flutter/material.dart';
import 'package:melodi_ai/core/service_locator.dart'; // <-- 1. Import "Văn phòng Quản lý"
import 'package:melodi_ai/routes/app_router.dart';

void main() {
  // 2. "Mở cửa văn phòng" trước khi chạy ứng dụng
  setupLocator(); 
  
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