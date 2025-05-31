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
      if (!_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final scrollPercentage = currentScroll / maxScroll;

      if (scrollPercentage >= 0.6 && !_isLoading && _hasMore) {
        _loadMore();
      }
    });
  }

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

    setState(() {
      _isLoading = false;
      _isFirstLoad = false;
    });
  }

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
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _refresh,
                color: Colors.indigo,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _posts.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < _posts.length) {
                      final post = _posts[index];
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
                        child: Center(child: CircularProgressIndicator()),
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
  final String? imageUrl; // รูปภาพในโพสต์
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

  final List<String> options = [
    "Add to Bookmarks",
    "Notify about posts",
    "Copy link",
    "interesting",
    "Not interesting",
    "Report",
  ];

  // icon
  final RxBool isSelectHeart = false.obs;

  final List<IconData> icons = [
    PhosphorIconsRegular.bookmarkSimple,
    PhosphorIconsRegular.bellSimple,
    PhosphorIconsRegular.copySimple,
    PhosphorIconsRegular.plusCircle,
    PhosphorIconsRegular.minusCircle,
    PhosphorIconsRegular.warningCircle,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0), // Margin ระหว่าง Card
      color: Colors.white,
      elevation: 2.0, // เงาใต้ Card
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
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(userProfile), // User profile
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                  ),
                  // More Options (...)
                  DropdownButton(
                    icon: Icon(
                      PhosphorIconsRegular.dotsThreeOutline,
                      color: Colors.grey[700],
                    ),
                    underline: const SizedBox.shrink(),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    items:
                        options.asMap().entries.map<DropdownMenuItem<String>>((
                          entry,
                        ) {
                          int index = entry.key;
                          String value = entry.value;
                          return DropdownMenuItem<String>(
                            value: value,
                            onTap: () {
                              // Handle more options
                            },
                            enabled: true,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 6,
                              children: [
                                // if (index == 5)
                                // const Divider(height: 4, thickness: 5, indent: 20, endIndent: 0, color: Colors.black),
                                Icon(icons[index], color: Colors.grey[700]),
                                Text(
                                  value,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (String? value) {
                      print(value);
                    },
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.more_horiz, color: Colors.grey[600]),
                  //   onPressed: () {
                  //     // Handle more options
                  //   },
                  // ),
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
                                size: 20,
                                color: Colors.red,
                              )
                              : Icon(
                                PhosphorIconsRegular.heart,
                                size: 20,
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
                          size: 20,
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
                      size: 20,
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
