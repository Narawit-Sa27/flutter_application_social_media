import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onPressed;

  const ProfileScreen({super.key, required this.onPressed});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
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
      child: DefaultTabController(
        length: 4,
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
                onPressed: () {},
              ),
              IconButton(
                icon: Badge(
                  label: Text("9"),
                  padding: EdgeInsets.all(2),
                  child: const Icon(
                    PhosphorIconsRegular.bellSimple,
                    size: 24.0,
                  ),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  PhosphorIconsRegular.dotsThreeOutlineVertical,
                  size: 24,
                ),
                onPressed: () {
                  widget.onPressed();
                },
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Column(
                children: [
                  const SizedBox(
                    height: 70,
                    width: 70,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        'https://media.istockphoto.com/id/2157394121/photo/portrait-of-confident-businesswoman-standing-in-office.webp?a=1&b=1&s=612x612&w=0&k=20&c=eK6hSqdHlfABi60Ipge_SkS1NsHGNf8Lnm0WSrZFGgA=',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'username',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Following 200',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  ProfileStat(title: "Posts", value: "200"),
                  SizedBox(
                    height: 30,
                    width: 1,
                    child: ColoredBox(key: Key("1"), color: Colors.grey),
                  ),
                  ProfileStat(title: "Followers", value: "40.5K"),
                  SizedBox(
                    height: 30,
                    width: 1,
                    child: ColoredBox(key: Key("2"), color: Colors.grey),
                  ),
                  ProfileStat(title: "Likes", value: "20K"),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 6,
                children: [
                  SizedBox(
                    height: 50,
                    width: 175,
                    child: FilledButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.indigo.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Edit profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 50,
                    width: 175,
                    child: FilledButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Share profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TabBar(
                controller: _controller,
                labelColor: Colors.indigoAccent,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.indigoAccent,
                tabs: const [
                  Tab(icon: Icon(PhosphorIconsRegular.squaresFour, size: 24.0)),
                  Tab(icon: Icon(PhosphorIconsRegular.heart, size: 24.0)),
                  Tab(icon: Icon(PhosphorIconsRegular.video, size: 24.0)),
                  Tab(
                    icon: Icon(PhosphorIconsRegular.bookmarkSimple, size: 24.0),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    Icon(Icons.flight, size: 150),
                    Icon(Icons.directions_car, size: 150),
                    TabScreenVideo(),
                    Icon(Icons.directions_boat, size: 150),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: const UploadReelButton(),
        ),
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String title;
  final String value;

  const ProfileStat({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

class TabScreenVideo extends StatelessWidget {
  const TabScreenVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 9,
      padding: EdgeInsets.only(top: 5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // จำนวนคอลัมน์
        crossAxisSpacing: 2,
        mainAxisSpacing: 3,
        childAspectRatio: 9 / 16, // สัดส่วนวิดีโอแนวตั้ง
      ),
      itemBuilder: (context, index) {
        return _buildBoxVideo();
      },
    );
  }

  Widget _buildBoxVideo(
    // Widget widget
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            "https://images.unsplash.com/photo-1748968218568-a5eac621e65c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyfHx8ZW58MHx8fHx8",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("Reel", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class UploadReelButton extends StatelessWidget {
  const UploadReelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        try {
          await uploadReel(); // เรียกใช้ฟังก์ชันที่อัปโหลดวิดีโอและ thumbnail
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Upload สำเร็จ")));
        } catch (error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Upload ไม่สำเร็จ")));
        }
      },
      child: Icon(Icons.upload),
      backgroundColor: Colors.pinkAccent,
      tooltip: "อัปโหลดวิดีโอ Reel",
    );
  }
}

Future<void> uploadReel() async {
  final picker = ImagePicker();
  final picked = await picker.pickVideo(source: ImageSource.gallery);

  if (picked == null) return;

  final videoFile = File(picked.path);
  final videoId = DateTime.now().millisecondsSinceEpoch.toString();

  // Upload video
  final videoRef = FirebaseStorage.instance.ref('reels/videos/$videoId.mp4');
  await videoRef.putFile(videoFile);
  final videoUrl = await videoRef.getDownloadURL();

  // Generate thumbnail
  final thumbData = await VideoThumbnail.thumbnailData(
    video: videoFile.path,
    imageFormat: ImageFormat.JPEG,
    quality: 75,
  );

  final thumbRef = FirebaseStorage.instance.ref(
    'reels/thumbnails/$videoId.jpg',
  );
  await thumbRef.putData(thumbData!);
  final thumbnailUrl = await thumbRef.getDownloadURL();

  // Save to Firestore
  await FirebaseFirestore.instance.collection('reels').add({
    'videoUrl': videoUrl,
    'thumbnailUrl': thumbnailUrl,
    'createdAt': FieldValue.serverTimestamp(),
    'userId': 'some-user-id',
  });
}
