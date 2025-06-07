import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:badges/badges.dart' as badges;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final List<String> _chats = [];
  bool _isLoadingMore = false;
  bool _isRefreshing = false;
  bool _hasMore = true;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInitialChats();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadMoreChats();
      }
    });
  }

  Future<void> _loadInitialChats() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _chats.clear();
      _chats.addAll(List.generate(10, (index) => 'Chat ${index + 1}'));
      _page = 1;
      _hasMore = true;
      _isRefreshing = false;
    });
  }

  Future<void> _loadMoreChats() async {
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      final newChats = List.generate(10, (i) => 'Chat ${_page * 10 + i + 1}');
      _chats.addAll(newChats);
      _page++;
      if (newChats.length < 10) _hasMore = false;
      _isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
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
              IconButton(
                icon: const Icon(
                  PhosphorIconsRegular.magnifyingGlass,
                  size: 24.0,
                ),
                onPressed: () {},
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Badge(
                label: Text("9"),
                padding: EdgeInsets.all(2),
                child: const Icon(PhosphorIconsRegular.bellSimple, size: 24.0),
              ),
              onPressed: () {},
            ),
          ],
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(80.0),
          //   child:
          // ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // 📸 Story Bar เป็น item แรก
            SizedBox(
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  DottedBorder(
                                    options: CustomPathDottedBorderOptions(
                                      customPath: (size) {
                                        // สร้าง path วงกลม
                                        final radius =
                                            min(size.width, size.height) / 2;
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
                                      color: Colors.indigoAccent,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  badges.Badge(
                                    badgeStyle: badges.BadgeStyle(
                                      shape: badges.BadgeShape.circle,
                                      badgeColor: Colors.green,
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      padding: EdgeInsets.all(8),
                                    ),
                                    position: badges.BadgePosition.bottomEnd(
                                      bottom: 5,
                                      end: 5,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.indigoAccent,
                                          width: 2,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(2),
                                      height: 70,
                                      width: 70,
                                      child: const CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                          'https://images.unsplash.com/photo-1543610892-0b1f7e6d8ac1?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D',
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
            ),
            PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: Container(
                width: 250.0, // Width tabBar
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Background tabBar
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  dividerHeight: 0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), // Creates border
                    color: Colors.indigo.shade600,
                  ), //Change background color from here
                  splashBorderRadius: BorderRadius.circular(12),
                  tabs: const [Tab(text: 'Messages'), Tab(text: 'Requests')],
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildChatTab(), // Messages
                    _buildPlaceholderTab(), // Requests
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    return RefreshIndicator(
      onRefresh: _loadInitialChats,
      color: Colors.indigoAccent,
      backgroundColor: Colors.white,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _chats.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _chats.length) {
            return ListTile(
              leading: const Badge(
                backgroundColor: Colors.green,
                smallSize: 10,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(child: Icon(Icons.person)),
                ),
              ),
              title: Text(
                _chats[index],
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Last message preview...',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 6,
                children: [
                  Text("8:30"),
                  Badge(label: Text("6"), backgroundColor: Colors.indigoAccent),
                ],
              ),
              onTap: () {},
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: Colors.indigoAccent),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPlaceholderTab() {
    return const Center(child: Text("No requests"));
  }
}
