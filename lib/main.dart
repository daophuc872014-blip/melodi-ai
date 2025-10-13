import 'package:flutter/material.dart';
import 'package:melodi_ai/routes/app_router.dart'; // Import "tấm bản đồ" của chúng ta

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng MaterialApp.router để báo cho Flutter biết chúng ta dùng GoRouter
    return MaterialApp.router(
      // Cung cấp cấu hình "bản đồ" mà chúng ta đã tạo
      routerConfig: appRouter,
      
      debugShowCheckedModeBanner: false,
      title: 'Melody.AI',
      
      // Định nghĩa theme chung cho ứng dụng để có giao diện nhất quán
      theme: ThemeData(
        // SỬA LỖI: Tên đúng là "Brightness.dark"
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F3057),
        primarySwatch: Colors.blue,
      ),
    );
  }
}