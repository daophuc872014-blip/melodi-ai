import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompletionPage extends StatelessWidget {
  const CompletionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Melody AI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDownloadCard(),
                _buildCtaButton(context),
                _buildSocialShare(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Text(
            'Tác phẩm của bạn đã sẵn sàng! 🎉',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Sáng tác của Bạn',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          const Text(
            'Gửi Quang, Ánh Sáng Của Ba Mẹ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFF8C69), Color(0xFFE75480)]),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                alignment: Alignment.center,
                child: const Text('Tải Về MP3 (Miễn phí)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFFFC779)),
            label: const Text('Tải Về WAV (Bản Chuyên nghiệp)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFC779))),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              side: BorderSide(color: const Color(0xFFFFC779).withOpacity(0.5), width: 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCtaButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.go('/');
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF5DE0E6), Color(0xFF004AAD)]),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'Sáng Tác Bài Hát Tiếp Theo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialShare() {
    return Column(
      children: [
        const Text('Chia sẻ tác phẩm của bạn', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(Icons.facebook),
            const SizedBox(width: 16),
            _buildSocialButton(Icons.video_collection_rounded),
            const SizedBox(width: 16),
            _buildSocialButton(Icons.share),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.white.withOpacity(0.1),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}