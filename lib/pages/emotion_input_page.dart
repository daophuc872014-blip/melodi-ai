import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmotionInputPage extends StatefulWidget {
  const EmotionInputPage({super.key});

  @override
  State<EmotionInputPage> createState() => _EmotionInputPageState();
}

class _EmotionInputPageState extends State<EmotionInputPage> {
  late final TextEditingController _textController;
  String? _selectedEmotion;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onEmotionTagPressed(String emotion) {
    setState(() {
      _textController.text = emotion;
      _selectedEmotion = emotion;
    });
  }

  void _createMelody() {
    final currentEmotion = _textController.text;
    if (currentEmotion.isNotEmpty) {
      print('Tạo giai điệu cho cảm xúc: $currentEmotion');
      context.push('/player');
    } else {
      print('Vui lòng chọn hoặc nhập một cảm xúc.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F3057),
              Color(0xFF00587A),
              Color(0xFFE75480),
              Color(0xFFFF8C69),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3, 0.85, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildBackgroundWaveCircle(),
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundWaveCircle() {
    return Center(
      child: Container(
        width: 224,
        height: 224,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.yellow.withAlpha((255 * 0.3).toInt()), width: 1),
        ),
        child: Center(
          child: SizedBox(
            height: 96,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(35, (index) {
                final height = Random().nextDouble() * 80 + 10;
                return Container(
                  width: 4,
                  height: height,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(128),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 64),
            const Column(
              children: [
                Text(
                  'Xin chào!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  '"Mỗi Cảm Xúc Đều Xứng Đáng Có Một Giai Điệu"',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  '*Hãy cứ là chính mình, tôi ở đây để lắng nghe*',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white70),
                ),
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
        const Text(
          'Giai điệu bạn đang tìm kiếm có cảm xúc như thế nào?',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
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
          onChanged: (text) {
            setState(() {
              _selectedEmotion = emotions.contains(text) ? text : null;
            });
          },
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: '...hoặc mô tả chi tiết hơn',
            hintStyle: TextStyle(color: Colors.white.withAlpha((255 * 0.6).toInt())),
            filled: true,
            fillColor: Colors.white.withAlpha((255 * 0.1).toInt()),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.white.withAlpha((255 * 0.3).toInt())),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.white.withAlpha((255 * 0.3).toInt())),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _createMelody,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 58),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF43A047),
                  Color(0xFF76FF03),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(118, 255, 3, 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Tạo Giai Điệu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black38,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
