/// Lớp Service GIẢ LẬP, chịu trách nhiệm mô phỏng việc tạo ra âm nhạc.
/// Nó giúp chúng ta phát triển giao diện và luồng người dùng mà không cần chờ API thật.
class MockMusicGenerationService {
  
  /// Mô phỏng việc gửi "bản kế hoạch" và nhận về URL của file MP3.
  ///
  /// [suggestion] là đối tượng Map nhận được từ AIService (hiện tại không dùng đến nhưng vẫn giữ để API tương thích).
  /// Luôn luôn trả về một URL MP3 mẫu sau một khoảng thời gian chờ.
  Future<String> generateMusic(Map<String, dynamic> suggestion) async {
    print(">>> [MOCK] Bắt đầu 'quá trình tạo nhạc' giả lập...");

    // Giả vờ "suy nghĩ" trong 5 giây để mô phỏng thời gian chờ của AI
    await Future.delayed(const Duration(seconds: 5));

    // Luôn trả về một URL của một file MP3 miễn phí, chất lượng tốt trên mạng.
    // Đây là một bản nhạc piano nhẹ nhàng.
    const mockMusicUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
    
    print(">>> [MOCK] 'Tạo nhạc' thành công! Trả về URL: $mockMusicUrl");

    return mockMusicUrl;
  }
}