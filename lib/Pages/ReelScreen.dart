import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  final List<String> videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    // เพิ่มลิงก์วิดีโออื่น ๆ ตามต้องการ
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.5, // เต็มหน้าจอ
    );

    //     _pageController.addListener(() {
    //   final currentPage = _pageController.page?.round();
    //   // ใช้ currentPage ทำสิ่งต่างๆ ได้ เช่น preload video ถัดไป
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        body: SafeArea(
          child: PageView.builder(
            controller: PageController(viewportFraction: 1.0),
            scrollDirection: Axis.vertical,
            itemCount: videoUrls.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  // Optionally apply a fade/scale effect here
                  return Transform.scale(
                    scale: 1.0,
                    child: Opacity(
                      opacity: 1.0,
                      child: ReelVideoPlayer(videoUrl: videoUrls[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class ReelVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const ReelVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _ReelVideoPlayerState createState() => _ReelVideoPlayerState();
}

class _ReelVideoPlayerState extends State<ReelVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // _controller.play();
        // _controller.setLooping(true);
        _controller.setVolume(1.0); // ensure sound
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // ปล่อย memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),

            // UI overlay เช่น username, like, share buttons
            Positioned(
              left: 16,
              bottom: 60,
              child: IconButton(
                icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                onPressed: () {
                  setState(() {
                    _isMuted = !_isMuted;
                    _controller.setVolume(_isMuted ? 0.0 : 1.0);
                  });
                },
              ),
            ),
            Positioned(
              left: 16,
              bottom: 60,
              child: Text(
                '@username',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('🔥 Nice shot!', style: TextStyle(color: Colors.white)),
                  Text('😂 LOL!', style: TextStyle(color: Colors.white)),
                  Text('💯 Fire bro!', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),

            Positioned(
              right: 16,
              bottom: 60,
              child: Column(
                children: const [
                  Icon(Icons.favorite, color: Colors.white),
                  SizedBox(height: 10),
                  Icon(Icons.comment, color: Colors.white),
                  SizedBox(height: 10),
                  Icon(Icons.share, color: Colors.white),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 20,
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(DateTime.now().second / 60),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    'https://i.imgur.com/Mt8sY9G.png',
                  ), // album cover
                ),
              ),
            ),
          ],
        )
        : const Center(child: CircularProgressIndicator(color: Colors.indigoAccent,));
  }
}
