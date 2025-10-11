import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool _isPlaying = false;
  int _currentRating = 0;

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _updateRating(int rating) {
    setState(() {
      if (_currentRating == rating) {
        _currentRating = 0;
      } else {
        _currentRating = rating;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
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
        Container(
          width: 224,
          height: 224,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFF8C69).withOpacity(0.5), width: 3),
          ),
        ),
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
            gradient: const LinearGradient(
              colors: [Color(0xFFE75480), Color(0xFFFF8C69)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSongInfo() {
    return const Column(
      children: [
        Text(
          'Sáng tác của Bạn',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Gửi Quang, Ánh Sáng Của Ba Mẹ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerControls() {
    const progress = 0.4;

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final double totalWidth = constraints.maxWidth;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  width: totalWidth * progress,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC779),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Positioned(
                  left: totalWidth * progress - 8,
                  top: -6,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFC779),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1:23', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text('3:45', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 36),
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8C69), Color(0xFFE75480)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE75480).withOpacity(0.5),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 36),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          'Bạn cảm nhận thế nào?',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starNumber = index + 1;
            return IconButton(
              onPressed: () => _updateRating(starNumber),
              icon: Icon(
                starNumber <= _currentRating
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: const Color(0xFFFFC779),
                size: 32,
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () {
            context.push('/completion');
          },
          child: const Text(
            'Hoàn tất & Chia sẻ →',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}