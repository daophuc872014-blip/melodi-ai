import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:melodi_ai/env.dart'; // <-- Sửa 1: Import chìa khóa mới

class MusicGenerationService {
  final String _sunoApiEndpoint = 'https://api.suno.ai/v1/generate/music'; 

  Future<String> generateMusic(Map<String, dynamic> suggestion) async {
    // Sửa 2: Dùng chìa khóa mới, an toàn và nhanh hơn
    final apiKey = Env.sunoApiKey; 

    final String musicPrompt = 
        "${suggestion['suggestedTitle'] ?? 'An emotional piece'}, "
        "a ${suggestion['mainEmotion'] ?? 'instrumental'} track, "
        "in a ${suggestion['suggestedScale'] ?? 'Major'} scale, "
        "featuring ${suggestion['suggestedInstruments']?.join(', ') ?? 'piano'}. "
        "Tempo around ${suggestion['suggestedTempoBPM'] ?? 100} BPM.";

    print(">>> Gửi yêu cầu tạo nhạc với prompt: $musicPrompt");

    final body = json.encode({
      'prompt': musicPrompt,
      'duration_seconds': 60,
      'format': 'mp3'
    });

    try {
      final response = await http.post(
        Uri.parse(_sunoApiEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final musicUrl = decodedResponse['music_url']; 
        if (musicUrl != null) {
          print(">>> Nhận được URL nhạc: $musicUrl");
          return musicUrl;
        } else {
          throw Exception('API không trả về URL nhạc.');
        }
      } else {
        throw Exception('Lỗi khi gọi API tạo nhạc: ${response.body}');
      }
    } catch (e) {
      print("Đã xảy ra lỗi trong MusicGenerationService: $e");
      rethrow;
    }
  }
} 