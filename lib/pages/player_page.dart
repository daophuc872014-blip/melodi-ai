import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';

// Lớp helper để chứa dữ liệu từ các stream
class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  const PositionData(this.position, this.bufferedPosition, this.duration);
}

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with TickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  late final AnimationController _rotationController;
  late final AnimationController _waveController;

  // Stream kết hợp để lắng nghe dữ liệu từ trình phát
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20), vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800), vsync: this,
    );

    // Lắng nghe trạng thái của trình phát thật để điều khiển animation
    _player.playerStateStream.listen((state) {
      if (mounted) {
        if (state.playing) {
          _rotationController.repeat();
          _waveController.repeat(reverse: true);
        } else {
          _rotationController.stop();
          _waveController.stop();
        }
      }
    });
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _player.setAsset('assets/audio/sample.mp3');
    } catch (e) {
      print("Lỗi khi load file audio: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _rotationController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), onPressed: () => context.pop()),
        backgroundColor: Colors.transparent, elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F3057), Color(0xFF00587A), Color(0xFFE75480), Color(0xFFFF8C69)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildVisualizer(),
                _buildSongInfo(),
                _buildPlayerControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisualizer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildCircularWaveVisualizer(),
        RotationTransition(
          turns: _rotationController,
          child: Container(
            width: 160, height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/seed/melodi-ai/200'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircularWaveVisualizer() {
    const int barCount = 60;
    const double visualizerRadius = 112;
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(barCount, (index) {
            final animationValue = sin((_waveController.value * pi));
            return Transform.rotate(
              angle: (index / barCount) * 2 * pi,
              child: Transform.translate(
                offset: const Offset(0, -visualizerRadius),
                child: Transform.scale(
                  scaleY: 0.2 + animationValue.abs() * 0.8,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 3,
                    height: 30 + (Random(index).nextDouble() * 10),
                    decoration: BoxDecoration(color: const Color(0xFFFF8C69), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSongInfo() {
    return const Column(
      children: [
        Text('Sáng tác của Bạn', style: TextStyle(color: Colors.white70, fontSize: 14)),
        SizedBox(height: 8),
        Text('Gửi Quang, Ánh Sáng Của Ba Mẹ', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }
  
  Widget _buildPlayerControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return Column(
              children: [
                _buildProgressBar(positionData),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(positionData?.position ?? Duration.zero), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(_formatDuration(positionData?.duration ?? Duration.zero), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 36)),
            _buildPlayPauseButton(),
            IconButton(onPressed: () {}, icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 36)),
          ],
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () { context.push('/completion'); },
          child: const Text('Hoàn tất & Chia sẻ →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildProgressBar(PositionData? positionData) {
    final position = positionData?.position ?? Duration.zero;
    final duration = positionData?.duration ?? Duration.zero;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        final double progressValue = (duration.inMilliseconds > 0)
            ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
            : 0.0;
        
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final seekPosition = details.localPosition.dx / totalWidth;
            final newPosition = duration * seekPosition;
            _player.seek(newPosition);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container( height: 6, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(3))),
              Container( width: totalWidth * progressValue, height: 6, decoration: BoxDecoration(color: const Color(0xFFFFC779), borderRadius: BorderRadius.circular(3))),
              Positioned(
                left: (totalWidth * progressValue) - 8,
                top: -5,
                child: Container( width: 16, height: 16, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayPauseButton() {
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;

        if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
          return const SizedBox( width: 70, height: 70, child: CircularProgressIndicator(color: Colors.white));
        } else if (playing != true) {
          return _buildPlayButton(Icons.play_arrow_rounded, _player.play);
        } else if (processingState != ProcessingState.completed) {
          return _buildPlayButton(Icons.pause_rounded, _player.pause);
        } else {
          return _buildPlayButton(Icons.replay_rounded, () => _player.seek(Duration.zero));
        }
      },
    );
  }

  Widget _buildPlayButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 70, height: 70,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFF8C69), Color(0xFFE75480)],
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 48),
      ),
    );
  }
}