// DÁN TOÀN BỘ CODE NÀY VÀO TỆP lib/pages/emotion_input_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart'; // Tạm thời không dùng
import 'package:melodi_ai/core/service_locator.dart';
import 'package:melodi_ai/services/ai_service.dart';
import 'package:melodi_ai/services/music_generation_service.dart';
import 'package:audioplayers/audioplayers.dart';


class EmotionInputPage extends StatefulWidget {
  const EmotionInputPage({super.key});
  @override
  State<EmotionInputPage> createState() => _EmotionInputPageState();
}

class _EmotionInputPageState extends State<EmotionInputPage>
    with TickerProviderStateMixin {
  final AIService _aiService = locator<AIService>();
  final MusicGenerationService _musicService =
      locator<MusicGenerationService>();
  final AudioPlayer _audioPlayer = AudioPlayer();

  late final TextEditingController _textController;
  late final TextEditingController _lyricsController;

  String? _selectedEmotion;
  // late final AnimationController _rotationController; // Không cần nữa
  late final AnimationController _waveController;
  late final AnimationController _colorController;
  late final AnimationController _pulseController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _lyricsController = TextEditingController();
    // _rotationController = // Không cần nữa
    //     AnimationController(duration: const Duration(seconds: 30), vsync: this)
    //       ..repeat();
    _waveController = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this)
      ..repeat(reverse: true);
    _colorController =
        AnimationController(duration: const Duration(seconds: 4), vsync: this)
          ..repeat();
    _pulseController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _textController.dispose();
    _lyricsController.dispose();
    // _rotationController.dispose(); // Không cần nữa
    _waveController.dispose();
    _colorController.dispose();
    _pulseController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onEmotionTagPressed(String emotion) {
    setState(() {
      _textController.text = emotion;
      _selectedEmotion = emotion;
    });
  }

  Future<void> _createMelody() async {
    final String currentEmotion = _textController.text;
    final String lyrics = _lyricsController.text;

    FocusScope.of(context).unfocus();

    if (currentEmotion.isEmpty || lyrics.isEmpty || _isLoading) {
      String errorMsg = "Vui lòng nhập đầy đủ thông tin!";
      if (currentEmotion.isEmpty) {
        errorMsg = "Vui lòng nhập cảm xúc (ví dụ: Vui, Buồn...)";
      } else if (lyrics.isEmpty) {
        errorMsg = "Vui lòng nhập lời bài hát (lyrics)";
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final musicSuggestion =
          await _aiService.getMusicSuggestion(currentEmotion);
      print('>>> KẾT QUẢ TỪ GEMINI: $musicSuggestion');

      print('>>> [KITS.AI] Đang gửi lời bài hát để tạo acapella...');
      final String filePath = await _musicService.generateVocalAcapella(lyrics);
      print('>>> ĐÃ NHẬN ĐƯỢC ĐƯỜNG DẪN ACAPELLA: $filePath');

      await _audioPlayer.stop();
      await _audioPlayer.play(DeviceFileSource(filePath));
      print('>>> ĐANG PHÁT THỬ ACAPELLA...');

      print(">>> TẠM THỜI CHƯA CHUYỂN SANG TRANG PLAYER.");

      // TODO: Sau khi có file nhạc từ Stable Audio, chuyển trang Player ở đây
      // if (mounted) {
      //   context.push('/player', extra: {
      //     'suggestion': musicSuggestion,
      //     'url': finalSongPath, // Đường dẫn file nhạc cuối cùng
      //   });
      // }

    } catch (e) {
      print('>>> ĐÃ CÓ LỖI XẢY RA KHI TẠO NHẠC: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Không thể tạo giai điệu: ${e.toString().replaceFirst("Exception: ", "")}')),
        );
      }
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F3057),
                Color(0xFF00587A),
                Color(0xFFE75480),
                Color(0xFFFF8C69)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.3, 0.85, 1.0],
            ),
          ),
          // Stack bây giờ chỉ chứa Visualizer làm nền và Nội dung ở trên
          child: Stack(
            alignment: Alignment.center, // Visualizer vẫn căn giữa
            children: [
              // Lớp nền Visualizer (chỉ còn sóng nhạc)
              _buildCentralVisualizer(),
              // Lớp nội dung (đã điều chỉnh khoảng cách)
              _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  // --- HÀM BUILD VISUALIZER ĐÃ SỬA ---
  Widget _buildCentralVisualizer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Chỉ giữ lại hiệu ứng sóng nhạc
        _buildCircularWave(),
        // ĐÃ XÓA Vòng tròn xoay và hình ảnh 'visualizer.png'
      ],
    );
  }

  // --- HÀM BUILD SÓNG NHẠC ĐÃ SỬA ---
  Widget _buildCircularWave() {
    const int barCount = 60;
    const double visualizerRadius = 112; // Bán kính gốc của visualizer
    final alignmentTween =
        AlignmentTween(begin: Alignment.topCenter, end: Alignment.bottomCenter);

    return AnimatedBuilder(
      animation:
          Listenable.merge([_waveController, _colorController, _pulseController]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Container nền mờ (điều chỉnh kích thước và độ mờ)
            Container(
              width: visualizerRadius * 1.5 + (_pulseController.value * 15), // Kích thước nhỏ hơn
              height: visualizerRadius * 1.5 + (_pulseController.value * 15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFE75480).withOpacity(0.08 * (1-_pulseController.value)), // Mờ hơn
                    const Color(0xFFE75480).withOpacity(0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
            // Các thanh sóng nhạc (đẩy ra xa hơn)
            ...List.generate(barCount, (index) {
              final random = Random(index);
              final animationValue =
                  sin((_waveController.value * 2 * pi) + (random.nextDouble() * pi));
              // Offset mới để đẩy các thanh sóng ra xa trung tâm
              final double barOffset = visualizerRadius + 50 + (animationValue.abs() * 20); // Điều chỉnh 50 để đẩy ra xa

              return Transform.rotate(
                angle: (index / barCount) * 2 * pi,
                child: Transform.translate(
                  offset: Offset(0, -barOffset), // Sử dụng offset mới
                  child: Transform.scale(
                    scaleY: 0.2 + animationValue.abs() * 0.8,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 3,
                      height: 30 + (animationValue.abs() * 20), // Chiều cao thanh sóng
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          begin: alignmentTween.evaluate(_colorController),
                          end: alignmentTween.transform(-1.0),
                          colors: const [
                            Color(0xFF00587A),
                            Color(0xFFE75480),
                            Color(0xFFFF8C69)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  // --- HÀM BUILD NỘI DUNG ĐÃ SỬA ---
  Widget _buildMainContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0), // Chỉ padding ngang
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Khoảng trống ở trên cùng (GIẢM Xuống)
              const SizedBox(height: 120), // <-- Đặt lại giá trị này

              // Các phần Text giữ nguyên
              const Text(
                'Melody AI',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white),
              ),
              const SizedBox(height: 64),
              const Column(
                children: [
                  Text('Xin chào!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('"Mỗi Cảm Xúc Đều Xứng Đáng Có Một Giai Điệu"', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('*Hãy cứ là chính mình, tôi ở đây để lắng nghe*', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 40), // Khoảng trống trước ô nhập

              // Khu vực nhập liệu (giữ nguyên)
              _buildEmotionInputArea(),

              const SizedBox(height: 20), // Khoảng trống dưới cùng
            ],
          ),
        ),
      ),
    );
  }

  // Hàm _buildEmotionInputArea giữ nguyên (không cần sửa nữa)
  // DÁN LẠI HÀM NÀY (ĐÃ SỬA LỖI /*...*/)
  // DÁN LẠI HÀM NÀY (ĐÃ SỬA LỖI hintText)
  Widget _buildEmotionInputArea() {
    final emotions = ['Vui', 'Buồn', 'Bình yên', 'Tức giận', 'Lãng mạn'];
    // --- Styles cho nút cảm xúc ---
    final defaultTagStyle = OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.white.withAlpha((255 * 0.1).toInt()),
      side: BorderSide(color: Colors.white.withAlpha((255 * 0.3).toInt())),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
    final selectedTagStyle = OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFFFF8C69).withAlpha(100),
      side: const BorderSide(color: Color(0xFFFF8C69)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
    // --- Kết thúc Styles ---

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Giai điệu bạn đang tìm kiếm có cảm xúc như thế nào?',
            style: TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 20),
        // --- ListView cho nút cảm xúc ---
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: emotions.length,
            itemBuilder: (context, index) {
              final emotion = emotions[index];
              final isSelected = _selectedEmotion == emotion;
              return OutlinedButton(
                onPressed: () => _onEmotionTagPressed(emotion),
                style: isSelected ? selectedTagStyle : defaultTagStyle,
                child: Text(emotion),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 8),
          ),
        ),
        // --- Kết thúc ListView ---
        const SizedBox(height: 20),
        // --- TextField Cảm xúc (ĐÃ THÊM LẠI decoration) ---
        TextField(
          controller: _textController,
          onChanged: (text) {
            setState(() {
              _selectedEmotion = emotions.contains(text) ? text : null;
            });
          },
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration( // <-- ĐÃ THÊM LẠI
            hintText: '...hoặc mô tả chi tiết hơn',
            hintStyle:
                TextStyle(color: Colors.white.withAlpha((255 * 0.6).toInt())),
            filled: true,
            fillColor: Colors.white.withAlpha((255 * 0.1).toInt()),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),
        // --- TextField Lyrics (ĐÃ THÊM LẠI decoration) ---
        TextField(
          controller: _lyricsController,
          textAlign: TextAlign.left,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration( // <-- ĐÃ THÊM LẠI
            hintText: 'Nhập lời bài hát (lyrics) tại đây...',
            hintStyle:
                TextStyle(color: Colors.white.withAlpha((255 * 0.6).toInt())),
            filled: true,
            fillColor: Colors.white.withAlpha((255 * 0.1).toInt()),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none),
          ),
          maxLines: 4,
        ),
        const SizedBox(height: 24),
        // --- Nút Tạo Giai Điệu ---
        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _createMelody,
            style: ElevatedButton.styleFrom( // <-- ĐÃ THÊM LẠI style
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              disabledBackgroundColor: Colors.grey.withOpacity(0.2),
            ),
            child: Ink( // <-- ĐÃ THÊM LẠI Ink và decoration
              decoration: BoxDecoration(
                gradient: _isLoading ? null : const LinearGradient(
                    colors: [Color(0xFF43A047), Color(0xFF76FF03)]),
                color: _isLoading ? Colors.grey.withOpacity(0.2) : null,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container( // <-- ĐÃ THÊM LẠI Container và nội dung bên trong
                alignment: Alignment.center,
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 3))
                    : const Text(
                        'Tạo Giai Điệu',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
              ),
            ),
          ),
        ),
        // --- Kết thúc Nút ---
      ],
    );
} 
}