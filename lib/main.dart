import 'package:flutter/material.dart';
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
      home:  const SignInPage()
      );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<StatefulWidget> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      tabs: [
        PersistentTabConfig(
          screen: Text('Page Home'),
          item: ItemConfig(
            icon:
                _controller == 0
                    ? Icon(PhosphorIconsFill.house, size: 24.0)
                    : Icon(PhosphorIconsRegular.house, size: 24.0),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: Text('Page Search'),
          item: ItemConfig(
            icon:
                _controller == 1
                    ? Icon(PhosphorIconsFill.magnifyingGlass, size: 24.0)
                    : Icon(PhosphorIconsRegular.magnifyingGlass, size: 24.0),
            title: "Search",
          ),
        ),
        PersistentTabConfig(
          screen: Text('Page Messages'),
          item: ItemConfig(
            icon: Badge(
              // animationType: BadgeAnimationType.scale,
              // badgeContent: UnreadIndicator(),
              child:
                  _controller == 2
                      ? Icon(PhosphorIconsFill.chatsCircle, size: 24.0)
                      : Icon(PhosphorIconsRegular.chatsCircle, size: 24.0),
            ),
            title: "Messages",
          ),
        ),
        PersistentTabConfig(
          screen: Text('Page Users'),
          navigatorConfig: NavigatorConfig(),
          scrollController: ScrollController(),
          item: ItemConfig(
            icon:
                _controller == 3
                    ? Icon(PhosphorIconsFill.user, size: 24.0)
                    : Icon(PhosphorIconsRegular.user, size: 24.0),
            title: "Users",
          ),
        ),
      ],
      navBarBuilder:
          (navBarConfig) => CustomNavBar( // Style5BottomNavBar(
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
              'Social.',
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
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: BottomNavigation(),
    );
  }
}

class CustomNavBar extends StatelessWidget {
  final NavBarConfig navBarConfig;

  // You are free to omit this, but in combination with `DecoratedNavBar` it might make your start easier
  final NavBarDecoration navBarDecoration;

  const CustomNavBar({
    super.key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
  });

  Widget _buildItem(ItemConfig item, bool isSelected) {
    final title = item.title;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: IconTheme(
            data: IconThemeData(
              size: item.iconSize,
              color:
                  isSelected
                      ? item.activeForegroundColor
                      : item.inactiveForegroundColor,
            ),
            child: isSelected ? item.icon : item.inactiveIcon,
          ),
        ),
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Material(
              type: MaterialType.transparency,
              child: FittedBox(
                child: Text(
                  title,
                  style: item.textStyle.apply(
                    color:
                        isSelected
                            ? item.activeForegroundColor
                            : item.inactiveForegroundColor,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedNavBar(
      decoration: navBarDecoration,
      height: kBottomNavigationBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (final (index, item) in navBarConfig.items.indexed)
            Expanded(
              child: InkWell(
                // This is the most important part. Without this, nothing would happen if you tap on an item.
                onTap: () => navBarConfig.onItemSelected(index),
                child: _buildItem(item, navBarConfig.selectedIndex == index),
              ),
            ),
        ],
      ),
    );
  }
}
