/// Lớp Service GIẢ LẬP, chịu trách nhiệm mô phỏng việc tạo ra âm nhạc.
/// Nó giúp chúng ta phát triển giao diện và luồng người dùng mà không cần chờ API thật.
class MockMusicGenerationService {
  /// Tiền tố log cho lớp Mock này.
  static const String _logPrefix = '>>> [MOCK]';

  /// Thời gian chờ giả lập (mô phỏng AI đang "suy nghĩ").
  static const Duration _mockDelay = Duration(seconds: 5);

  /// URL của file nhạc mẫu trả về.
  /// Đây là một bản nhạc piano nhẹ nhàng (SoundHelix Song 1).
  static const String _mockMusicUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  /// Mô phỏng việc gửi "bản kế hoạch" và nhận về URL của file MP3.
  ///
  /// [suggestion] là đối tượng Map nhận được từ AIService (hiện tại không dùng đến
  /// nhưng vẫn giữ để API tương thích).
  /// Luôn luôn trả về một URL MP3 mẫu sau một khoảng thời gian chờ.
  Future<String> generateMusic(Map<String, dynamic> suggestion) async {
    // Tham số `suggestion` không được dùng trong Mock, nhưng giữ để tương thích API.
    print("$_logPrefix Bắt đầu 'quá trình tạo nhạc' giả lập...");

    // Giả vờ "suy nghĩ" để mô phỏng thời gian chờ của AI
    await Future.delayed(_mockDelay);

    // Luôn trả về một URL của một file MP3 mẫu.
    print("$_logPrefix 'Tạo nhạc' thành công! Trả về URL: $_mockMusicUrl");

    return _mockMusicUrl;
  }
}