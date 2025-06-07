import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReelScreen extends StatefulWidget {
  final VoidCallback onPressed;

  const ReelScreen({super.key, required this.onPressed});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  final PageController _pageController = PageController();
  List<VideoItem> data = [];
  int currentPage = 0;
  final RxBool activeHeart = false.obs;

  @override
  void initState() {
    super.initState();
    loadInitialVideos();
    _pageController.addListener(onScroll);
  }

  Future<void> loadInitialVideos() async {
    final videos = await fetchMockVideos();
    setState(() {
      data = videos;
    });

    // preload ก่อน render เสร็จ
    await preloadController(0);
    await preloadController(1);

    // await UI before create success then play video
    WidgetsBinding.instance.addPostFrameCallback((_) {
      data[0].videoController?.play();
    });
  }

  void onScroll() {
    final page = _pageController.page?.round() ?? 0;
    if (page != currentPage) {
      disposeController(currentPage - 1);
      preloadController(page);
      preloadController(page + 1);

      // ✅ สั่งเล่นซ้ำเพื่อความชัวร์
      final controller = data[page].videoController;
      if (controller != null && controller.value.isInitialized) {
        controller.play();
      }

      currentPage = page;
    }
  }

  Future<List<VideoItem>> fetchMockVideos() async {
    return [
      VideoItem(
        name: "Bob",
        imageUrl:
            "https://images.pexels.com/photos/1040881/pexels-photo-1040881.jpeg?auto=compress&cs=tinysrgb&w=600",
        videoUrl:
            "https://github.com/Narawit-Sa27/flutter_application_social_media/raw/refs/heads/main/assets/Download.mp4",
      ),
      VideoItem(
        name: "Bob",
        imageUrl:
            "https://images.pexels.com/photos/1040881/pexels-photo-1040881.jpeg?auto=compress&cs=tinysrgb&w=600",
        videoUrl:
            "https://videos.pexels.com/video-files/6185445/6185445-sd_506_960_25fps.mp4",
      ),
      VideoItem(
        name: "Alice",
        imageUrl:
            "https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&w=600",
        videoUrl:
            "https://videos.pexels.com/video-files/5377684/5377684-sd_640_360_25fps.mp4",
      ),
      VideoItem(
        name: "Charlie",
        imageUrl:
            "https://images.pexels.com/photos/343717/pexels-photo-343717.jpeg?auto=compress&cs=tinysrgb&w=600",
        videoUrl:
            "https://videos.pexels.com/video-files/5528011/5528011-sd_360_640_25fps.mp4",
      ),
      // เพิ่มได้ตามต้องการ
    ];
  }

  Future<void> preloadController(int index) async {
    if (index < 0 || index >= data.length) return;
    final item = data[index];

    if (item.videoController != null) return; // ✅ ป้องกัน preload ซ้ำ

    final controller = VideoPlayerController.network(item.videoUrl);
    await controller.initialize();
    controller.setLooping(true);
    await controller.play(); // ✅ สำคัญ

    final chewie = ChewieController(
      videoPlayerController: controller,
      autoPlay: true,
      looping: true,
      showControls: true,
      customControls: CustomControls(),
    );

    setState(() {
      item.videoController = controller;
      item.chewieController = chewie;
    });
  }

  void disposeController(int index) {
    if (index < 0 || index >= data.length) return;
    final item = data[index];
    item.chewieController?.dispose();
    item.videoController?.dispose();
    item.chewieController = null;
    item.videoController = null;
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var item in data) {
      item.chewieController?.dispose();
      item.videoController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Change style color status Bar
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(
          0,
          0,
          0,
          0.94,
        ), // Background color Status Bar
        statusBarIconBrightness: Brightness.light, // icon or text color
        statusBarBrightness: Brightness.dark, // for iOS color
      ),
      child: Theme(
        data: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigoAccent,
            // brightness: Brightness.dark,
          ),
        ),
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.94),
          body: VisibilityDetector(
            // 👈 check display screen
            key: const Key("reel-screen"),
            onVisibilityChanged: (info) {
              if (info.visibleFraction == 0) {
                // change screen home, message, ... pause video
                for (var item in data) {
                  if (item.chewieController != null &&
                      item.videoController?.value.isInitialized == true) {
                    item.videoController?.pause();
                  }
                }
              } else {
                // change screen reel video play. await UI before create success then play video
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  data[0].videoController?.play();
                });
              }
            },
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];

                if (item.chewieController != null &&
                    item.videoController?.value.isInitialized == true) {
                  final bool verticalVideo =
                      item.videoController!.value.size.height >
                      item.videoController!.value.size.width;
                  return Stack(
                    key: PageStorageKey(item),
                    children: [
                      verticalVideo
                          ? SizedBox.expand(
                            child: FittedBox(
                              fit:
                                  BoxFit
                                      .cover, // สำคัญ: ทำให้วิดีโอเต็มพื้นที่ (อาจถูก crop)
                              child: SizedBox(
                                width: item.videoController!.value.size.width,
                                height: item.videoController!.value.size.height,
                                child: Chewie(
                                  controller: item.chewieController!,
                                ),
                              ),
                            ),
                          )
                          : Chewie(controller: item.chewieController!),
                      Positioned(
                        left: 16,
                        bottom: 90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                item.imageUrl,
                              ), // album cover
                            ),
                            Text(
                              item.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            // Text('🔥 Nice shot!', style: TextStyle(color: Colors.white)),
                            // Text('😂 LOL!', style: TextStyle(color: Colors.white)),
                            Text(
                              '💯 Fire bro!',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        right: 16,
                        bottom: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 15,
                          children: [
                            Obx(
                              () => _buildActionIcon(
                                activeHeart.value
                                    ? Icon(
                                      PhosphorIconsFill.heart,
                                      color: Colors.red,
                                    )
                                    : Icon(
                                      PhosphorIconsRegular.heart,
                                      color: Colors.white,
                                    ),
                                "20.2K",
                                () {
                                  activeHeart.toggle();
                                },
                              ),
                            ),
                            _buildActionIcon(
                              Icon(
                                PhosphorIconsRegular.chatCircleDots,
                                color: Colors.white,
                              ),
                              "3,221",
                              () {},
                            ),
                            _buildActionIcon(
                              Icon(
                                PhosphorIconsRegular.paperPlaneTilt,
                                color: Colors.white,
                              ),
                              "13",
                              () {},
                            ),
                            IconButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                widget.onPressed();
                              },
                              icon: Icon(
                                PhosphorIconsRegular.dotsThreeOutline,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PlayListSound(),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.indigoAccent,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon(
    Widget iconButton,
    String subButton,
    VoidCallback onPressed,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 2,
      children: [
        IconButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: onPressed,
          icon: iconButton,
        ),
        Text(subButton, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

class VideoItem {
  final String name;
  final String imageUrl;
  final String videoUrl;
  VideoPlayerController? videoController;
  ChewieController? chewieController;

  VideoItem({
    required this.name,
    required this.imageUrl,
    required this.videoUrl,
  });
}

class CustomControls extends StatefulWidget {
  const CustomControls({super.key});

  @override
  State<CustomControls> createState() => _CustomControlsState();
}

class _CustomControlsState extends State<CustomControls> {
  bool _showControls = false;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final chewieController = ChewieController.of(context)!;
    final videoController = chewieController.videoPlayerController;

    return GestureDetector(
      // Touch Screen
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          // if video playing touch screen pause video
          videoController.value.isPlaying
              ? videoController.pause()
              : videoController.play();
          _isPlaying =
              !videoController
                  .value
                  .isPlaying; // Value = false when video pause opposite video playing
          _showControls = _isPlaying; // Value = false
        });
        // Show controls if video pause (false, true)
        if (_showControls && !_isPlaying) {
          // Hide controls if video playing in 1 sec (true, true)
          Future.delayed(Duration(seconds: 1), () {
            if (mounted) {
              setState(() => _showControls = false); // 👈 👁️ Hide controls
            }
          });
        }
      },
      child: Stack(
        children: [
          // Show button pause and prev next 5sec
          if (_showControls)
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 45,
                    color: Colors.white,
                    icon: Icon(Icons.replay_5),
                    onPressed: () {
                      final pos = videoController.value.position;
                      videoController.seekTo(pos - Duration(seconds: 5));
                    },
                  ),
                  IconButton(
                    iconSize: 55,
                    color: Colors.white,
                    icon: Icon(
                      videoController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        videoController.value.isPlaying
                            ? videoController.pause()
                            : videoController.play();
                        // Touch icon button Value = false when video pause
                        _isPlaying = !videoController.value.isPlaying;
                        // Value = true
                        _showControls = !_isPlaying;
                        // Hide controls (true, true)
                        if (_showControls && !_isPlaying) {
                          // Hide controls if video playing in 1 sec
                          Future.delayed(Duration(seconds: 1), () {
                            if (mounted) {
                              setState(
                                () => _showControls = false,
                              ); // 👈 👁️ Hide controls
                            }
                          });
                        }
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 45,
                    color: Colors.white,
                    icon: Icon(Icons.forward_5),
                    onPressed: () {
                      final pos = videoController.value.position;
                      videoController.seekTo(pos + Duration(seconds: 5));
                    },
                  ),
                ],
              ),
            ),

          // Video progress bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.rectangle),
              height: !_isPlaying ? 7 : 10,
              child: VideoProgressIndicator(
                videoController,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.indigoAccent,
                  backgroundColor: Colors.grey,
                  bufferedColor: Colors.white38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayListSound extends StatefulWidget {
  const PlayListSound({super.key});

  // final VideoItem data;
  // final VoidCallback onPressed;

  // const PlayListSound({super.key, required this.data, required this.onPressed});

  @override
  _PlayListSoundState createState() => _PlayListSoundState();
}

class _PlayListSoundState extends State<PlayListSound>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _isMuted = false;
  late AnimationController _controllerRotation;

  @override
  void initState() {
    super.initState();
    // _controller = widget.data.controller!;
    // ..initialize().then((_) {
    //   // _controller.play();
    //   // _controller.setLooping(true);
    //   _controller.setVolume(1.0); // ensure sound
    //   setState(() {});
    // });

    _controllerRotation = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(); // infinity loop rotate
  }

  @override
  void dispose() {
    _controllerRotation.dispose();
    super.dispose();
  }

  // **นี่คือจุดสำคัญที่บอกให้ widget เก็บสถานะไว้**
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // เรียก super เพื่อให้ keep alive ทำงาน

    return
    // UI overlay เช่น username, like, share buttons
    // Positioned(
    //   left: 16,
    //   bottom: 60,
    //   child: IconButton(
    //     icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
    //     onPressed: () {
    //       setState(() {
    //         _isMuted = !_isMuted;
    //         _controller.setVolume(_isMuted ? 0.0 : 1.0);
    //       });
    //     },
    //   ),
    // ),
    Positioned(
      right: 16,
      bottom: 20,
      child: AnimatedBuilder(
        animation: _controllerRotation,
        builder: (context, child) {
          return AnimatedRotation(
            turns: _controllerRotation.value * 1.0,
            duration: Duration.zero,
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://i.imgur.com/Mt8sY9G.png',
              ), // album cover
            ),
          );
        },
      ),
    );
  }
}
