// Dán toàn bộ nội dung file emotion_input_page.dart hoàn chỉnh vào đây
// (Đây là phiên bản đầy đủ nhất, đã có ClipOval)
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:melodi_ai/services/ai_service.dart';
import 'package:melodi_ai/services/mock_music_generation_service.dart';

class EmotionInputPage extends StatefulWidget {
  const EmotionInputPage({super.key});
  @override
  State<EmotionInputPage> createState() => _EmotionInputPageState();
}

class _EmotionInputPageState extends State<EmotionInputPage> with TickerProviderStateMixin {
  late final TextEditingController _textController;
  String? _selectedEmotion;
  late final AnimationController _rotationController;
  late final AnimationController _waveController;
  late final AnimationController _colorController;
  late final AnimationController _pulseController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _rotationController = AnimationController(duration: const Duration(seconds: 30), vsync: this)..repeat();
    _waveController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this)..repeat(reverse: true);
    _colorController = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat();
    _pulseController = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _textController.dispose();
    _rotationController.dispose();
    _waveController.dispose();
    _colorController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onEmotionTagPressed(String emotion) {
    setState(() {
      _textController.text = emotion;
      _selectedEmotion = emotion;
    });
  }

  Future<void> _createMelody() async {
    final currentEmotion = _textController.text;
    if (currentEmotion.isEmpty || _isLoading) return;
    setState(() { _isLoading = true; });
    try {
      final musicSuggestion = await AIService().getMusicSuggestion(currentEmotion);
      print('>>> KẾT QUẢ TỪ GEMINI: $musicSuggestion');
      final audioUrl = await MockMusicGenerationService().generateMusic(musicSuggestion);
      if (mounted) {
        context.push(
          '/player', 
          extra: {'suggestion': musicSuggestion, 'url': audioUrl},
        );
      }
    } catch (e) {
      print('>>> ĐÃ CÓ LỖI XẢY RA: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể tạo giai điệu: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F3057), Color(0xFF00587A), Color(0xFFE75480), Color(0xFFFF8C69)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.0, 0.3, 0.85, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [_buildCentralVisualizer(), _buildMainContent()],
        ),
      ),
    );
  }

  Widget _buildCentralVisualizer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildCircularWave(),
        RotationTransition(
          turns: _rotationController,
          child: ClipOval( // THÊM KHUÔN CẮT HÌNH TRÒN
            child: Image.asset(
              'assets/images/visualizer.png',
              width: 224,
              height: 224,
              fit: BoxFit.cover, // Dùng BoxFit.cover để lấp đầy hình tròn
            ),
          ),
        ),
      ],
    );
  }

  // ... (Các hàm còn lại giữ nguyên)
  Widget _buildCircularWave(){
      const int barCount = 60;
      const double visualizerRadius = 112; 
      final alignmentTween = AlignmentTween(begin: Alignment.topCenter, end: Alignment.bottomCenter);

      return AnimatedBuilder(
        animation: Listenable.merge([_waveController, _colorController, _pulseController]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: visualizerRadius,
                height: visualizerRadius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFE75480).withOpacity(0.3),
                      const Color(0xFFE75480).withOpacity(0),
                    ],
                    stops: [0.0, _pulseController.value],
                  ),
                ),
              ),
              ...List.generate(barCount, (index) {
                final random = Random(index);
                final animationValue = sin((_waveController.value * 2 * pi) + (random.nextDouble() * pi));
                return Transform.rotate(
                  angle: (index / barCount) * 2 * pi,
                  child: Transform.translate(
                    offset: const Offset(0, -visualizerRadius),
                    child: Transform.scale(
                      scaleY: 0.2 + animationValue.abs() * 0.8,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 3,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            begin: alignmentTween.evaluate(_colorController),
                            end: alignmentTween.transform(-1.0),
                            colors: const [Color(0xFF00587A), Color(0xFFE75480), Color(0xFFFF8C69)],
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

  Widget _buildMainContent() {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                'Melody AI',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white),
              ),
              const SizedBox(height: 64),
              const Column(
                children: [
                  Text( 'Xin chào!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 8),
                  Text( '"Mỗi Cảm Xúc Đều Xứng Đáng Có Một Giai Điệu"', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                  SizedBox(height: 8),
                  Text( '*Hãy cứ là chính mình, tôi ở đây để lắng nghe*', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white70)),
                ],
              ),
              const Spacer(),
              _buildEmotionInputArea(),
            ],
          ),
        ),
      );
  }

  Widget _buildEmotionInputArea() {
      final emotions = ['Vui', 'Buồn', 'Bình yên', 'Tức giận', 'Lãng mạn'];
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Giai điệu bạn đang tìm kiếm có cảm xúc như thế nào?', style: TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 20),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
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
          const SizedBox(height: 20),
          TextField(
            controller: _textController,
            onChanged: (text) { setState(() { _selectedEmotion = emotions.contains(text) ? text : null; }); },
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '...hoặc mô tả chi tiết hơn',
              hintStyle: TextStyle(color: Colors.white.withAlpha((255 * 0.6).toInt())),
              filled: true,
              fillColor: Colors.white.withAlpha((255 * 0.1).toInt()),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _createMelody,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                disabledBackgroundColor: Colors.grey.withOpacity(0.2),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF43A047), Color(0xFF76FF03)]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: _isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text(
                          'Tạo Giai Điệu',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ),
          ),
        ],
      );
  }
}