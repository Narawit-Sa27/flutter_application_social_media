import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_socail_media/Pages/CommentPage.dart';
import 'package:flutter_application_socail_media/Pages/SearchBarAllPage.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_application_socail_media/Model/Post.dart';
import 'dart:convert';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiOverlayStyle, rootBundle;
import 'package:dotted_border/dotted_border.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<Post> _posts = [];
  List<Post> _allPosts = [];

  bool _isLoading = false;
  bool _isFirstLoad = true;
  bool _hasMore = true;

  int _page = 0;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadMore();

    _scrollController.addListener(() {
      // Return early if the scroll controller is not ready
      if (!_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final scrollPercentage = currentScroll / maxScroll;

      // Load more when scrolled past 70% of the list
      if (scrollPercentage >= 1.0 && !_isLoading && _hasMore) {
        _loadMore();
      }
    });
  }

  // Loads the full JSON only once and caches it
  Future<void> _loadAllJsonPosts() async {
    if (_allPosts.isEmpty) {
      try {
        final String response = await rootBundle.loadString(
          'assets/mocks/mock_users_home_screen.json',
        );
        final List<dynamic> data = json.decode(response);
        _allPosts = data.map((json) => Post.fromJson(json)).toList();
      } catch (e) {
        debugPrint('Error loading posts: $e');
        _hasMore = false;
      }
    }
  }

  // Paginated loading logic
  Future<void> _loadMore() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    await _loadAllJsonPosts();

    final int start = _page * _pageSize;
    final int end = start + _pageSize;

    if (start >= _allPosts.length) {
      _hasMore = false;
    } else {
      final newItems = _allPosts.sublist(start, end.clamp(0, _allPosts.length));
      _posts.addAll(newItems);
      _page++;
    }

    // Delay for loading data mock api if not written, will not be seen loading because it is too fast.
    await Future.delayed(const Duration(seconds: 1)); // 🕧
    setState(() {
      _isLoading = false;
      _isFirstLoad = false;
    });
  }

  // Pull-to-refresh logic
  Future<void> _refresh() async {
    setState(() {
      _posts.clear();
      _page = 0;
      _hasMore = true;
      _isFirstLoad = true;
    });

    await _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigoAccent,
          brightness: Brightness.light,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Image.asset(
                'assets/social_icon.png', // ไอคอนแอป
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Commune',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                PhosphorIconsRegular.magnifyingGlass,
                size: 24.0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchBar1()),
                );
              },
            ),
            IconButton(
              icon: Badge(
                label: Text("9"),
                padding: EdgeInsets.all(2),
                child: const Icon(PhosphorIconsRegular.bellSimple, size: 24.0),
              ),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.grey[100],
        body:
            _isFirstLoad
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.indigoAccent),
                )
                : RefreshIndicator(
                  onRefresh: _refresh,
                  color: Colors.indigoAccent,
                  backgroundColor: Colors.white,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        _posts.length +
                        (_hasMore ? 2 : 1), // +1 สำหรับ StoryBar
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // 📸 Story Bar เป็น item แรก
                        return SizedBox(
                          height: 110,
                          child: ColoredBox(
                            color: Colors.white,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              separatorBuilder:
                                  (context, index) => const SizedBox(width: 12),
                              itemBuilder:
                                  (context, index) =>
                                      index == 0
                                          ? Column(
                                            children: [
                                              DottedBorder(
                                                options:
                                                    CustomPathDottedBorderOptions(
                                                      customPath: (size) {
                                                        // สร้าง path วงกลม
                                                        final radius =
                                                            min(
                                                              size.width,
                                                              size.height,
                                                            ) /
                                                            2;
                                                        return Path()..addOval(
                                                          Rect.fromCircle(
                                                            center: Offset(
                                                              size.width / 2,
                                                              size.height / 2,
                                                            ),
                                                            radius: radius,
                                                          ),
                                                        );
                                                      },
                                                      dashPattern: [8, 12],
                                                      color:
                                                          Colors.indigoAccent,
                                                      strokeWidth: 2,
                                                    ),
                                                child: SizedBox(
                                                  height: 65,
                                                  width: 65,
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      PhosphorIconsRegular.plus,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Text(
                                                'Add to story',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          )
                                          : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              badges.Badge(
                                                badgeStyle: badges.BadgeStyle(
                                                  shape:
                                                      badges.BadgeShape.circle,
                                                  badgeColor: Colors.green,
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 2,
                                                  ),
                                                  padding: EdgeInsets.all(8),
                                                ),
                                                position: badges
                                                    .BadgePosition.bottomEnd(
                                                  bottom: 5,
                                                  end: 5,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color:
                                                          Colors.indigoAccent,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                  height: 70,
                                                  width: 70,
                                                  child: const CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage: NetworkImage(
                                                      'https://media.istockphoto.com/id/2157394121/photo/portrait-of-confident-businesswoman-standing-in-office.webp?a=1&b=1&s=612x612&w=0&k=20&c=eK6hSqdHlfABi60Ipge_SkS1NsHGNf8Lnm0WSrZFGgA=',
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Text(
                                                'username',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                            ),
                          ),
                        );
                      }

                      final adjustedIndex = index - 1;

                      if (adjustedIndex < _posts.length) {
                        final post = _posts[adjustedIndex];
                        return SocialPostCard(
                          index: index,
                          userProfile: post.userProfile,
                          userName: post.userName,
                          userHandle: post.userHandle,
                          timeAgo: post.timeAgo,
                          postText: post.postText,
                          imageUrl: post.imageUrl,
                          likes: post.likes,
                          comments: post.comments,
                          shares: post.shares,
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.indigoAccent,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class SocialPostCard extends StatelessWidget {
  final int? index;
  final String userProfile;
  final String userName;
  final String userHandle;
  final String timeAgo;
  final String postText;
  final String? imageUrl; // image Post
  final int likes;
  final int comments;
  final int shares;

  SocialPostCard({
    super.key,
    this.index,
    required this.userProfile,
    required this.userName,
    required this.userHandle,
    required this.timeAgo,
    required this.postText,
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  });

  // Dropdown tab list
  final List<String> options = [
    "Notify about posts",
    "Copy link",
    "Interesting",
    "Not interesting",
    "Report",
  ];

  // icon
  final RxBool isSelectHeart = false.obs;
  final RxBool isSelectBookmark = false.obs;
  // icon Dropdown tab list
  final List<IconData> icons = [
    PhosphorIconsRegular.bellSimple,
    PhosphorIconsRegular.copySimple,
    PhosphorIconsRegular.plusCircle,
    PhosphorIconsRegular.minusCircle,
    PhosphorIconsRegular.warningOctagon,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          (index != null && index == 1)
              ? const EdgeInsets.symmetric(vertical: 0)
              : const EdgeInsets.symmetric(
                vertical: 4.0,
              ), // Margin between Card
      color: Colors.white,
      elevation: 2.0, // shadow Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero, // delete padding
                            shape: const CircleBorder(), // style shape button
                            tapTargetSize:
                                MaterialTapTargetSize
                                    .shrinkWrap, // reduce hit area
                            elevation: 0, // shadow
                            backgroundColor:
                                Colors
                                    .transparent, // If you don't want a button background
                            shadowColor: Colors.grey[50],
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(userProfile),
                          ),
                        ),

                        const SizedBox(width: 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero, // ไม่บังคับขนาดขั้นต่ำ
                                tapTargetSize:
                                    MaterialTapTargetSize
                                        .shrinkWrap, // ไม่ขยาย hitbox เกินตัวอักษร
                                shape: const RoundedRectangleBorder(),
                                foregroundColor: Colors.grey,
                                surfaceTintColor: Colors.grey,
                                shadowColor: Colors.transparent,
                              ),
                              child: Text(
                                userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                            Text(
                              '$userHandle • $timeAgo',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // More Options (...)
                    PopupMenuButton<String>(
                      borderRadius: BorderRadius.circular(24),
                      padding: EdgeInsets.zero,
                      color: Colors.white,
                      onSelected: (value) {
                        // handle action
                      },
                      itemBuilder:
                          (context) =>
                              options.asMap().entries.map((entry) {
                                int index = entry.key;
                                String value = entry.value;
                                return PopupMenuItem<String>(
                                  padding: EdgeInsets.all(0),
                                  value: value,
                                  child: PopupMenuItem(
                                    value: value,
                                    child: Column(
                                      children: [
                                        if (index == 3 ||
                                            index ==
                                                5) // create line in menu on interesting & report
                                          const Divider(
                                            height: 0.5,
                                            color: Color.fromARGB(
                                              255,
                                              213,
                                              213,
                                              213,
                                            ),
                                          ),
                                        // Expanded(
                                        // child:
                                        Align(
                                          alignment: Alignment.center,
                                          heightFactor: 1.9,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 6,
                                            children: [
                                              Icon(
                                                icons[index],
                                                color:
                                                    index == 4
                                                        ? Colors.red
                                                        : Colors.grey[700],
                                              ),
                                              Text(
                                                value,
                                                style: TextStyle(
                                                  color:
                                                      index == 4
                                                          ? Colors.red
                                                          : Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                          // ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                      icon: Icon(
                        PhosphorIconsRegular.dotsThreeOutline,
                        color: Colors.grey[700],
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Post Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ElevatedButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey,
                  surfaceTintColor: Colors.grey,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  postText,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
            ),

            if (imageUrl != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 460, // 👈 maxHeight card post
                    minHeight: 230,
                  ),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Center(child: Icon(Icons.error)),
                        ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),

            // Action Buttons (Likes, Comments, Shares)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Obx(
                        () => _buildActionButton(
                          isSelectHeart.value
                              ? Icon(
                                PhosphorIconsFill.heart,
                                size: 22,
                                color: Colors.red,
                              )
                              : Icon(
                                PhosphorIconsRegular.heart,
                                size: 22,
                                color: Colors.grey[800],
                              ),
                          '$likes',
                          () {
                            isSelectHeart.toggle();
                          },
                        ),
                      ),
                      _buildActionButton(
                        Icon(
                          PhosphorIconsRegular.chatCircleDots,
                          size: 22,
                          color: Colors.grey[800],
                        ),
                        '$comments',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentPage(),
                            ),
                          );
                        },
                      ),
                      _buildActionButton(
                        Icon(
                          PhosphorIconsRegular.paperPlaneTilt,
                          size: 22,
                          color: Colors.grey[800],
                        ),
                        '$shares',
                        () {},
                      ),
                    ],
                  ),
                  Obx(
                    () => _buildActionButton(
                      isSelectBookmark.value
                          ? Icon(
                            PhosphorIconsFill.bookmarkSimple,
                            size: 22,
                            color: Colors.yellow[700],
                          )
                          : Icon(
                            PhosphorIconsRegular.bookmarkSimple,
                            size: 22,
                            color: Colors.grey[800],
                          ),
                      '',
                      () {
                        isSelectBookmark.toggle();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    Icon iconWidget,
    String text,
    VoidCallback onPressed,
  ) {
    return text == ""
        ? IconButton(
          onPressed: onPressed,
          icon: iconWidget,
          style: TextButton.styleFrom(backgroundColor: Colors.grey[100]),
        )
        : TextButton.icon(
          onPressed: onPressed,
          icon: iconWidget,
          label: Text(text, style: TextStyle(color: Colors.grey[800])),
          style: TextButton.styleFrom(backgroundColor: Colors.grey[100]),
        );
  }
}
