import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_application_socail_media/Services/Post.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body:
          _isFirstLoad
              ? const Center(
                child: CircularProgressIndicator(color: Colors.indigoAccent),
              )
              : RefreshIndicator(
                onRefresh: _refresh,
                color: Colors.indigoAccent,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount:
                      _posts.length + (_hasMore ? 2 : 1), // +1 สำหรับ StoryBar
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // 📸 Story Bar เป็น item แรก
                      return SizedBox(
                        height: 90,
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
                              (context, index) => Column(
                                children: [
                                  const CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                      'https://media.istockphoto.com/id/2157394121/photo/portrait-of-confident-businesswoman-standing-in-office.webp?a=1&b=1&s=612x612&w=0&k=20&c=eK6hSqdHlfABi60Ipge_SkS1NsHGNf8Lnm0WSrZFGgA=',
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
                      );
                    }

                    final adjustedIndex = index - 1;

                    if (adjustedIndex < _posts.length) {
                      final post = _posts[adjustedIndex];
                      return SocialPostCard(
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
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class SocialPostCard extends StatelessWidget {
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
    "Add to Bookmarks",
    "Notify about posts",
    "Copy link",
    "Interesting",
    "Not interesting",
    "Report",
  ];

  // icon
  final RxBool isSelectHeart = false.obs;
  // icon Dropdown tab list
  final List<IconData> icons = [
    PhosphorIconsRegular.bookmarkSimple,
    PhosphorIconsRegular.bellSimple,
    PhosphorIconsRegular.copySimple,
    PhosphorIconsRegular.plusCircle,
    PhosphorIconsRegular.minusCircle,
    PhosphorIconsRegular.warningOctagon,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0), // Margin between Card
      color: Colors.white,
      elevation: 2.0, // shadow Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          userProfile,
                        ), // User profile
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (index == 3 ||
                                          index ==
                                              5) // create line in menu on interesting & report
                                        const Divider(
                                          height: 0.5,
                                          color: Colors.grey,
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
                                                  index == 5
                                                      ? Colors.red
                                                      : Colors.grey[700],
                                            ),
                                            Text(
                                              value,
                                              style: TextStyle(
                                                color: Colors.grey[700],
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
            const SizedBox(height: 6),

            // Post Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(postText, style: const TextStyle(fontSize: 15)),
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
                                size: 24,
                                color: Colors.red,
                              )
                              : Icon(
                                PhosphorIconsRegular.heart,
                                size: 24,
                                color: Colors.grey[700],
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
                          size: 24,
                          color: Colors.grey[700],
                        ),
                        '$comments',
                        () {},
                      ),
                    ],
                  ),

                  _buildActionButton(
                    Icon(
                      PhosphorIconsRegular.shareFat,
                      size: 24,
                      color: Colors.grey[700],
                    ),
                    '$shares',
                    () {},
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
    return TextButton.icon(
      onPressed: onPressed,
      icon: iconWidget,
      label: Text(text, style: TextStyle(color: Colors.grey[700])),
      style: TextButton.styleFrom(backgroundColor: Colors.grey[100]),
    );
  }
}
