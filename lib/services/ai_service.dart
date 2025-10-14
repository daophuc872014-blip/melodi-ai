import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:melodi_ai/env.dart'; // <-- THAY ĐỔI 1: Import chìa khóa mới

class AIService {
  Future<Map<String, dynamic>> getMusicSuggestion(String userEmotion) async {
    // THAY ĐỔI 2: Dùng chìa khóa mới, an toàn và nhanh hơn
    final apiKey = Env.geminiApiKey; 

    // Dòng code MỚI và ĐÚNG NHẤT
final url = Uri.parse('https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$apiKey');
    
    final prompt = """
    Bạn là một chuyên gia về âm nhạc và cảm xúc. Hãy phân tích đoạn văn bản sau đây về cảm xúc của người dùng và trả về một đối tượng JSON DUY NHẤT, không có bất kỳ giải thích nào khác. Đoạn văn: \"$userEmotion\". Đối tượng JSON phải có các trường sau: 'mainEmotion' (string - cảm xúc chính), 'suggestedTempoBPM' (int - nhịp độ đề xuất), 'suggestedScale' (string - 'Major' hoặc 'Minor'), 'suggestedInstruments' (array of strings - 3 nhạc cụ đề xuất), 'suggestedTitle' (string - một tên bài hát sáng tạo), 'suggestedAlbumArtPrompt' (string - một câu mô tả để tạo hình ảnh bìa album).
    """;
    
    final body = json.encode({
      "contents": [{"parts": [{"text": prompt}]}]
    });
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final rawJsonString = decodedResponse['candidates'][0]['content']['parts'][0]['text'];
        final cleanedJsonString = rawJsonString.replaceAll('```json', '').replaceAll('```', '').trim();
        return json.decode(cleanedJsonString);
      } else {
        throw Exception('Lỗi khi gọi Gemini API: ${response.body}');
      }
    } catch (e) {
      print("Đã xảy ra lỗi trong AIService: $e");
      rethrow;
    }
  }
} 