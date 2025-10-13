// lib/services/ai_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Lớp AIService chịu trách nhiệm xử lý tất cả các tương tác
/// với Google Gemini API để lấy gợi ý âm nhạc dựa trên cảm xúc.
class AIService {
  // --- BIẾN CẤU HÌNH ---

  // TODO: Thay thế 'YOUR_GEMINI_API_KEY' bằng API key thực tế của bạn.
  // LƯU Ý BẢO MẬT: Đây là cách làm không an toàn. Trong một dự án thực tế,
  // hãy sử dụng các phương pháp như biến môi trường (environment variables)
  // hoặc remote config để bảo vệ API key.
  static const String _apiKey = 'gen-lang-client-0278488486';

  // Endpoint của Google Gemini API cho model 'gemini-pro'.
  static const String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$_apiKey';

  // --- PHƯƠNG THỨC CÔNG KHAI (PUBLIC METHOD) ---

  /// Gửi một yêu cầu đến Gemini API để nhận gợi ý bài hát dựa trên cảm xúc của người dùng.
  ///
  /// [userEmotion] là một chuỗi mô tả cảm xúc của người dùng (ví dụ: "vui vẻ", "buồn bã").
  /// Trả về một `Future<Map<String, dynamic>>` chứa thông tin chi tiết về bài hát
  /// nếu thành công, hoặc ném ra một ngoại lệ (Exception) nếu thất bại.
  Future<Map<String, dynamic>> getMusicSuggestion(String userEmotion) async {
    // Header cho yêu cầu HTTP POST, chỉ định rằng body là định dạng JSON.
    final headers = {
      'Content-Type': 'application/json',
    };

    // Prompt được thiết kế để yêu cầu Gemini trả về một đối tượng JSON có cấu trúc.
    // Việc này giúp việc phân tích (parse) dữ liệu ở phía client trở nên dễ dàng và ổn định.
    final prompt = _buildPrompt(userEmotion);

    // Cấu trúc body của yêu cầu theo định dạng mà Gemini API yêu cầu.
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ]
    });

    try {
      // Thực hiện cuộc gọi mạng bằng phương thức POST.
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: body,
      );

      // Kiểm tra xem yêu cầu có thành công không (status code 200).
      if (response.statusCode == 200) {
        // Phân tích cú pháp phản hồi từ API.
        // Gemini trả về một chuỗi JSON bên trong một cấu trúc JSON khác,
        // vì vậy chúng ta cần decode hai lần.
        final responseBody = jsonDecode(response.body);
        final musicSuggestionString =
            responseBody['candidates'][0]['content']['parts'][0]['text'];
        
        // Loại bỏ các ký tự ```json và ``` ở đầu và cuối chuỗi nếu có.
        final cleanedJsonString = musicSuggestionString.replaceAll(RegExp(r'```json|```'), '').trim();

        return jsonDecode(cleanedJsonString) as Map<String, dynamic>;
      } else {
        // Nếu API trả về lỗi, ném ra một Exception để tầng trên (UI) có thể xử lý.
        throw Exception(
            'Lỗi khi gọi Gemini API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Bắt và ném lại các lỗi mạng hoặc lỗi phân tích cú pháp.
      throw Exception('Không thể kết nối hoặc xử lý phản hồi: $e');
    }
  }

  // --- PHƯƠNG THỨC NỘI BỘ (PRIVATE METHOD) ---

  /// Xây dựng prompt hoàn chỉnh để gửi đến Gemini API.
  String _buildPrompt(String emotion) {
    // Đây là Prompt v1.
    // Việc tách prompt ra một hàm riêng giúp dễ dàng quản lý và thay đổi
    // các phiên bản prompt trong tương lai (Prompt v2, v3, ...).
    return """
      Bạn là một chuyên gia gợi ý âm nhạc tinh tế.
      Dựa trên cảm xúc được cung cấp, hãy gợi ý MỘT bài hát phù hợp nhất.
      Cảm xúc của người dùng là: "$emotion"

      Hãy trả về câu trả lời của bạn DUY NHẤT dưới dạng một đối tượng JSON hợp lệ, không có bất kỳ văn bản giải thích nào khác.
      Đối tượng JSON phải có các khóa sau:
      - "song_title": Tên bài hát (String).
      - "artist": Tên nghệ sĩ (String).
      - "album_art_url": Một URL hình ảnh bìa album chất lượng cao, có thể truy cập công khai (String).
      - "genre": Thể loại âm nhạc (String).
      - "reasoning": Một câu ngắn gọn giải thích tại sao bài hát này phù hợp với cảm xúc trên (String).

      Ví dụ về định dạng JSON đầu ra mong muốn:
      {
        "song_title": "Happy",
        "artist": "Pharrell Williams",
        "album_art_url": "https://example.com/happy_album_art.jpg",
        "genre": "Pop",
        "reasoning": "Giai điệu vui tươi và lời ca lạc quan của bài hát này là liều thuốc hoàn hảo cho một ngày tràn đầy năng lượng."
      }
    """;
  }
}