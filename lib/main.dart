import 'package:flutter/material.dart';
import 'package:flutter_application_socail_media/Pages/HomeScreen.dart';
import 'package:flutter_application_socail_media/Pages/login-register/ChangePasswordPage.dart';
import 'package:flutter_application_socail_media/Pages/login-register/OTPCodePage.dart';
import 'package:flutter_application_socail_media/Pages/login-register/PhoneNumberPage.dart';
import 'package:flutter_application_socail_media/Pages/login-register/SignInPage.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: SocialApp(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<StatefulWidget> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      tabs: [
        PersistentTabConfig(
          screen: HomeScreen(),
          item: ItemConfig(
            icon: Icon(PhosphorIconsRegular.house, size: 28.0),
            // title: "Home",
            activeForegroundColor: Colors.indigoAccent,
          ),
        ),
        PersistentTabConfig(
          screen: Text('Page Reel'),
          item: ItemConfig(
            icon: Icon(PhosphorIconsRegular.video, size: 28.0),
            // title: "Reel",
            activeForegroundColor: Colors.indigoAccent,
          ),
        ),
        PersistentTabConfig.noScreen(
          item: ItemConfig(
            icon: const Icon(PhosphorIconsRegular.plus, size: 20.0, color: Colors.white,),
            // title: "Post",
            activeForegroundColor: Colors.indigoAccent,
            // inactiveForegroundColor: Colors.grey,
          ),
          onPressed: (context) {
            // setState(() {
            //   _hideTab = !_hideTab;
            // });
          },
        ),
        PersistentTabConfig(
          screen: Text('Page Messages'),
          item: ItemConfig(
            icon: Badge(
              child: Icon(PhosphorIconsRegular.chatsCircle, size: 28.0),
            ),
            // title: "Messages",
            activeForegroundColor: Colors.indigoAccent,
          ),
        ),
        PersistentTabConfig(
          screen: Text('Page Users'),
          navigatorConfig: NavigatorConfig(),
          scrollController: ScrollController(),
          item: ItemConfig(
            icon: Icon(PhosphorIconsRegular.user, size: 28.0),
            // title: "Users",
            activeForegroundColor: Colors.indigoAccent,
          ),
        ),
      ],
      navBarBuilder:
          (navBarConfig) => // CustomNavBar(
            Style15BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(66, 187, 187, 187),
                  blurRadius: 10,
                ),
              ],
            ),
            // itemAnimationProperties: ItemAnimation(
            //   duration: const Duration(milliseconds: 400),
            //   curve: Curves.easeInOut,
            // ),
          ),
    );
  }
}

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: const Icon(PhosphorIconsRegular.magnifyingGlass, size: 24.0),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(PhosphorIconsRegular.bellSimple, size: 24.0),
            onPressed: () {},
          ),
        ],
      ),
      body: BottomNavigation(),
    );
  }
}
