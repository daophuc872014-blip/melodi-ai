import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodi_ai/core/service_locator.dart';
import 'package:melodi_ai/services/ai_service.dart';
import 'package:melodi_ai/services/mock_music_generation_service.dart';

// ----- BƯỚC 1: ĐỊNH NGHĨA CÁC TRẠNG THÁI CÓ THỂ XẢY RA -----
// Sealed class giúp chúng ta định nghĩa một tập hợp các trạng thái một cách an toàn
sealed class MelodyState {}

// Trạng thái ban đầu, chưa làm gì cả
class MelodyInitial extends MelodyState {}

// Trạng thái đang tải (giống như _isLoading = true)
class MelodyLoading extends MelodyState {}

// Trạng thái thành công, chứa "gói hàng" dữ liệu
class MelodySuccess extends MelodyState {
  final Map<String, dynamic> musicSuggestion;
  final String audioUrl;
  MelodySuccess({required this.musicSuggestion, required this.audioUrl});
}

// Trạng thái thất bại, chứa thông báo lỗi
class MelodyError extends MelodyState {
  final String message;
  MelodyError(this.message);
}


// ----- BƯỚC 2: TẠO "BỘ ĐIỀU KHIỂN" (THE NOTIFIER) -----
// Đây là nơi chứa toàn bộ logic nghiệp vụ
class MelodyNotifier extends Notifier<MelodyState> {
  // Lấy các service từ "Người quản lý" get_it
  final AIService _aiService = locator<AIService>();
  final MockMusicGenerationService _mockMusicService = locator<MockMusicGenerationService>();

  // build() là hàm được gọi để thiết lập trạng thái ban đầu
  @override
  MelodyState build() {
    return MelodyInitial(); // Trạng thái ban đầu là "chưa làm gì"
  }

  // Đây chính là hàm _createMelody() cũ của chúng ta, đã được chuyển vào đây
  Future<void> createMelody(String emotion) async {
    // 1. Phát đi tín hiệu "Đang tải..."
    state = MelodyLoading();

    try {
      // 2. Thực hiện công việc nặng nhọc
      final musicSuggestion = await _aiService.getMusicSuggestion(emotion);
      final audioUrl = await _mockMusicService.generateMusic(musicSuggestion);

      // 3. Nếu thành công, phát đi tín hiệu "Thành công" kèm theo dữ liệu
      state = MelodySuccess(musicSuggestion: musicSuggestion, audioUrl: audioUrl);
    } catch (e) {
      // 4. Nếu thất bại, phát đi tín hiệu "Thất bại" kèm theo thông báo lỗi
      state = MelodyError(e.toString());
    }
  }
}


// ----- BƯỚC 3: TẠO "KÊNH PHÁT THANH" (THE PROVIDER) -----
// Đây là "kênh" mà giao diện sẽ "lắng nghe".
final melodyProvider = NotifierProvider<MelodyNotifier, MelodyState>(
  () {
    return MelodyNotifier();
  },
);
