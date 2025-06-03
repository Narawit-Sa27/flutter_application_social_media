import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
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
                    child: const CircleAvatar(
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
                    child: ColoredBox(color: Colors.grey),
                  ),
                  ProfileStat(title: "Followers", value: "40.5K"),
                  SizedBox(
                    height: 30,
                    width: 1,
                    child: ColoredBox(color: Colors.grey),
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
                        backgroundColor: Colors.grey[200],
                      ),
                      child: Text(
                        "Edit profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
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
                      ),
                      child: Text(
                        "Edit profile",
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
              const TabBar(
                labelColor: Colors.indigoAccent,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(icon: Icon(PhosphorIconsRegular.squaresFour, size: 24.0)),
                  Tab(icon: Icon(PhosphorIconsRegular.heart, size: 24.0)),
                  Tab(icon: Icon(PhosphorIconsRegular.video, size: 24.0)),
                  Tab(
                    icon: Icon(PhosphorIconsRegular.bookmarkSimple, size: 24.0),
                  ),
                ],
              ),
            ],
          ),
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
