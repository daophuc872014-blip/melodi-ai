// DÁN TOÀN BỘ CODE NÀY VÀO TỆP lib/services/music_generation_service.dart

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MusicGenerationService {
  
  // -------------------------------------------------------------------
  // ⚠️ BƯỚC 1: DÁN API KEY CỦA BẠN VÀO ĐÂY
  // (Lấy từ trang "Developer" / "API" trên Kits.ai)
  final String _apiKey = "Uj9v9c4m.D6pQE2qtFdm2LKsetakJEZz9";

  // ⚠️ BƯỚC 2: DÁN VOICE ID CỦA BẠN VÀO ĐÂY
  // (Ví dụ: ID của "Nhạc Pop Emo Nam" sau khi nhấp vào thẻ)
  final String _voiceId = "TrLsRgJvyyKgVp8PU4uCx.wav";
  // -------------------------------------------------------------------


  // URL này là VÍ DỤ. Bạn CÓ THỂ cần kiểm tra lại tài liệu API của Kits.ai
  // để xem đúng URL cho "Text-to-Singing" là gì.
  final String _apiUrl = "https://api.kits.ai/v1/generate/tts";

  /// Tải file âm thanh từ URL Kits.ai trả về và lưu vào bộ nhớ tạm.
  /// Trả về đường dẫn (filePath) của tệp đã lưu.
  Future<String> _downloadAndSaveAudio(String audioUrl) async {
    print(">>> [KITS.AI SERVICE] Đang tải file audio từ: $audioUrl");
    try {
      final downloadResponse = await http.get(Uri.parse(audioUrl));
      
      if (downloadResponse.statusCode == 200) {
        final bytes = downloadResponse.bodyBytes;
        if (bytes.isEmpty) {
          throw Exception('File audio tải về bị rỗng.');
        }

        final dir = await getTemporaryDirectory();
        final filePath = '${dir.path}/generated_vocal_${DateTime.now().millisecondsSinceEpoch}.wav';
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        print(">>> [KITS.AI SERVICE] Đã lưu file acapella tại: $filePath");
        return filePath;
      } else {
        throw Exception('Lỗi khi tải file audio: ${downloadResponse.statusCode}');
      }
    } catch (e) {
      print(">>> [KITS.AI SERVICE] Lỗi khi tải hoặc lưu file: $e");
      rethrow;
    }
  }

  /// Hàm chính: Gọi Kits.ai để tạo giọng hát (acapella) từ văn bản (lyrics).
  /// Trả về đường dẫn file âm thanh đã lưu trên máy.
  Future<String> generateVocalAcapella(String lyrics) async {
    
    // Kiểm tra xem người dùng đã nhập Key và ID chưa
    if (_apiKey == "DÁN_API_KEY_CỦA_BẠN_VÀO_ĐÂY" || _voiceId == "DÁN_VOICE_ID_CỦA_BẠN_VÀO_ĐÂY") {
      print(">>> [KITS.AI SERVICE] LỖI: Vui lòng dán API Key và Voice ID vào code.");
      throw Exception("LỖI CẤU HÌNH: API Key hoặc Voice ID chưa được thiết lập.");
    }

    print(">>> [KITS.AI SERVICE] Bắt đầu tạo giọng hát (acapella)...");

    // ⚠️ Cấu trúc body này là VÍ DỤ. Hãy kiểm tra lại tài liệu API của Kits.ai
    // để đảm bảo tên các trường là chính xác (ví dụ: 'text' hay 'lyrics', 'voice_id' hay 'model_id')
    final body = jsonEncode({
      'text': lyrics,
      'voice_id': _voiceId,
      // 'pitch_shift': 0 // Có thể có các tham số khác
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          // ⚠️ Tên header này ('x-api-key') cũng là VÍ DỤ.
          // Kits.ai có thể dùng 'Authorization': 'Bearer $_apiKey'
          // Hãy KIỂM TRA LẠI TÀI LIỆU API của họ.
          'x-api-key': _apiKey, 
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print(">>> [KITS.AI SERVICE] Tạo acapella thành công! Đang chờ URL...");
        final decodedResponse = json.decode(response.body);

        // ⚠️ Tên trường 'audio_url' này là VÍ DỤ.
        // API có thể trả về một cấu trúc JSON khác, ví dụ: decodedResponse['data']['audio_url']
        // Hãy KIỂM TRA LẠI TÀI LIỆU API.
        final String? audioUrl = decodedResponse['audio_url']; 

        if (audioUrl != null && audioUrl.isNotEmpty) {
          print(">>> [KITS.AI SERVICE] Đã nhận được URL audio.");
          // Tải file về và trả về đường dẫn
          return await _downloadAndSaveAudio(audioUrl);
        } else {
          print(">>> [KITS.AI SERVICE] Lỗi: API không trả về 'audio_url' hợp lệ.");
          print(">>> [KITS.AI SERVICE] Phản hồi nhận được: ${response.body}");
          throw Exception('API không trả về audio_url hợp lệ.');
        }
      } else {
        print(">>> [KITS.AI SERVICE] Lỗi API: ${response.statusCode}");
        print(">>> [KITS.AI SERVICE] Body: ${response.body}");
        throw Exception('Lỗi khi gọi Kits.ai API: ${response.body}');
      }
    } on Exception catch (e) {
      print(">>> [KITS.AI SERVICE] Đã có lỗi xảy ra: $e");
      rethrow;
    } catch (e) {
      print(">>> [KITS.AI SERVICE] Đã có lỗi không xác định: $e");
      rethrow;
    }
  }
}