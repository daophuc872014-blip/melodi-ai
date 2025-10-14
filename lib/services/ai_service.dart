import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AIService {
  Future<Map<String, dynamic>> getMusicSuggestion(String userEmotion) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception("Lỗi: Không tìm thấy GEMINI_API_KEY trong file .env");
    }

    // Đã sửa lại URL, sử dụng phiên bản v1 ổn định
  // Dòng code MỚI và ĐÚNG NHẤT
// Dòng code MỚI và ĐÚNG NHẤT
final url = Uri.parse('https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$apiKey');

    final prompt = """
    Bạn là một chuyên gia về âm nhạc và cảm xúc. Hãy phân tích đoạn văn bản sau đây về cảm xúc của người dùng và trả về một đối tượng JSON DUY NHẤT, không có bất kỳ giải thích nào khác. Đoạn văn: \"$userEmotion\". Đối tượng JSON phải có các trường sau: 'mainEmotion' (string - cảm xúc chính), 'suggestedTempoBPM' (int - nhịp độ đề xuất), 'suggestedScale' (string - 'Major' hoặc 'Minor'), 'suggestedInstruments' (array of strings - 3 nhạc cụ đề xuất), 'suggestedTitle' (string - một tên bài hát sáng tạo), 'suggestedAlbumArtPrompt' (string - một câu mô tả để tạo hình ảnh bìa album).
    """;

    // Đã sửa lại body, xóa bỏ phần "generationConfig" không còn hợp lệ
    final body = json.encode({
      "contents": [{"parts": [{"text": prompt}]}]
    });

 try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // THAY ĐỔI QUAN TRỌNG: Thêm bước "dọn dẹp" chuỗi JSON ở đây
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        // Lấy chuỗi thô từ Gemini, có thể chứa Markdown
        final rawJsonString = decodedResponse['candidates'][0]['content']['parts'][0]['text'];
        
        // BƯỚC 1: "Mở phong bì" - Dọn dẹp các ký tự Markdown
        final cleanedJsonString = rawJsonString.replaceAll('```json', '').replaceAll('```', '').trim();

        // BƯỚC 2: "Đọc nội dung thư" - Giải mã chuỗi JSON đã được làm sạch
        return json.decode(cleanedJsonString);

      } else {
        // Ném ra lỗi để khối catch ở giao diện có thể bắt được và hiển thị
        throw Exception('Lỗi khi gọi Gemini API: ${response.body}');
      }
    } catch (e) {
      // Bắt các lỗi mạng và ném lại để giao diện xử lý
      print("Đã xảy ra lỗi trong AIService: $e");
      rethrow;
    }
  } // <-- Đây là dấu ngoặc đóng của hàm "getMusicSuggestion"
} // <-- Đây là dấu ngoặc đóng của lớp "AIService"