import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodi_ai/core/service_locator.dart';
import 'package:melodi_ai/routes/app_router.dart';

// --- Điểm bắt đầu của ứng dụng (Application Entry Point) ---
void main() async {
  // Đảm bảo các Flutter binding đã được khởi tạo trước khi chạy bất kỳ mã nào.
  // Đây là bước bắt buộc khi hàm main được đánh dấu là `async`.
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo service locator. Chuyển sang `await` để sẵn sàng cho
  // các tác vụ khởi tạo bất đồng bộ trong tương lai (ví dụ: Firebase, SharedPreferences).
  setupLocator();

  // Bọc toàn bộ ứng dụng trong ProviderScope để kích hoạt và cung cấp
  // state management của Riverpod cho toàn bộ cây widget.
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// --- Widget gốc của ứng dụng (Root Widget) ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Cấu hình router từ go_router hoặc một thư viện tương tự.
      routerConfig: appRouter,

      // Tắt banner "Debug" ở góc trên bên phải màn hình.
      debugShowCheckedModeBanner: false,

      title: 'Melody.AI',

      // Áp dụng theme đã được định nghĩa và tối ưu hóa ở dưới.
      theme: _appTheme,
    );
  }
}

// --- Cấu hình Theme tập trung (Centralized Theme Configuration) ---
// Tách biệt cấu hình theme ra khỏi logic của widget giúp mã nguồn sạch sẽ,
// dễ quản lý và tái sử dụng hơn.

final _appTheme = ThemeData(
  brightness: Brightness.dark,

  // Sử dụng ColorScheme.fromSeed để tạo một bảng màu nhất quán và hài hòa.
  // Đây là cách tiếp cận hiện đại, tuân thủ Material 3 và thay thế cho `primarySwatch`.
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF0F3057), // Màu gốc để tự động tạo ra các sắc thái màu khác.
    brightness: Brightness.dark,
  ),

  scaffoldBackgroundColor: const Color(0xFF0F3057),

  // Bật các tính năng và giao diện của Material 3 để ứng dụng trông hiện đại hơn.
  useMaterial3: true,
);
