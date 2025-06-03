import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
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
                child: const Icon(PhosphorIconsRegular.bellSimple, size: 24.0),
              ),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.indigoAccent[50],
        body: Text("Profile Page"),
      ),
    );
  }
}
