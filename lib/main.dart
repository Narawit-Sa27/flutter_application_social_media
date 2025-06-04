import 'package:flutter/material.dart';
import 'package:flutter_application_socail_media/Pages/ChatScreen.dart';
import 'package:flutter_application_socail_media/Pages/HomeScreen.dart';
import 'package:flutter_application_socail_media/Pages/ProfileScreen.dart';
import 'package:flutter_application_socail_media/Pages/ReelScreen.dart';
import 'package:flutter_application_socail_media/Pages/SettingPage.dart';
import 'package:flutter_application_socail_media/Pages/login-register/ChangePasswordPage.dart';
import 'package:flutter_application_socail_media/Pages/login-register/OTPCodePage.dart';
import 'package:flutter_application_socail_media/Pages/login-register/PhoneNumberPage.dart';
import 'package:flutter_application_socail_media/Pages/login-register/SignInPage.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const SocialApp(),
    );
  }
}

RxBool isDark = false.obs;

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const BottomNavigation();
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<StatefulWidget> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0, // 📲 Start page (Home)
  );

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      tabs: [
        PersistentTabConfig(
          screen: HomeScreen(),
          item: ItemConfig(
            icon: Badge(child: const Icon(PhosphorIconsFill.house, size: 28.0)),
            title: "Home",
            activeForegroundColor: Colors.indigoAccent,
            inactiveIcon: Badge(
              child: const Icon(PhosphorIconsRegular.house, size: 28.0),
            ),
            inactiveForegroundColor: Color(0xFF757575),
          ),
        ),
        PersistentTabConfig(
          screen: ReelScreen(),
          item: ItemConfig(
            icon: const Icon(PhosphorIconsFill.video, size: 28.0),
            title: "Reel",
            activeForegroundColor: Colors.indigoAccent,
            inactiveIcon: const Icon(PhosphorIconsRegular.video, size: 28.0),
            inactiveForegroundColor: Color(0xFF757575),
          ),
        ),
        PersistentTabConfig.noScreen(
          item: ItemConfig(
            icon: const Icon(
              PhosphorIconsRegular.plus,
              size: 20.0,
              color: Colors.white,
            ),
            // title: "Post",
            activeForegroundColor: Colors.indigoAccent,
            // inactiveForegroundColor: Colors.grey,
          ),
          onPressed: (context) {},
        ),
        PersistentTabConfig(
          screen: ChatScreen(),
          item: ItemConfig(
            icon: Badge(
              label: Text("10"),
              padding: EdgeInsets.all(2),
              child: const Icon(PhosphorIconsFill.chatsCircle, size: 28.0),
            ),
            title: "Messages",
            activeForegroundColor: Colors.indigoAccent,
            inactiveIcon: Badge(
              label: Text("10"),
              padding: EdgeInsets.all(2),
              child: const Icon(PhosphorIconsRegular.chatsCircle, size: 28.0),
            ),
            inactiveForegroundColor: Color(0xFF757575),
          ),
        ),
        PersistentTabConfig(
          screen: ProfileScreen(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildModalList(
                          const Icon(PhosphorIconsRegular.gear, size: 28.0),
                          "Settings and privacy",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                                  return SettingPage();
                                },
                              ),
                            );
                          },
                        ),
                        _buildModalList(
                          const Icon(
                            PhosphorIconsRegular.clockCounterClockwise,
                            size: 28.0,
                          ),
                          "History",
                          () {},
                        ),
                        _buildModalList(
                          const Icon(
                            PhosphorIconsRegular.creditCard,
                            size: 28.0,
                          ),
                          "Ordering and Payment",
                          () {},
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          item: ItemConfig(
            icon: const Icon(PhosphorIconsFill.user, size: 28.0),
            title: "Profile",
            activeForegroundColor: Colors.indigoAccent,
            inactiveIcon: const Icon(PhosphorIconsRegular.user, size: 28.0),
            inactiveForegroundColor: Color(0xFF757575),
          ),
        ),
      ],
      onTabChanged:
          (value) => value == 1 ? isDark.value = true : isDark.value = false,
      navBarBuilder:
          (navBarConfig) => // CustomNavBar(
              Obx(
            () =>
                isDark.value
                    ? Style15BottomNavBar(
                      navBarConfig: navBarConfig,
                      navBarDecoration: const NavBarDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.94),
                        // borderRadius: BorderRadius.circular(8),
                        border: Border(
                          top: BorderSide(
                            color: Color.fromARGB(255, 62, 62, 62),
                            width: 0.5,
                          ),
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Color.fromARGB(66, 187, 187, 187),
                        //     blurRadius: 10,
                        //   ),
                        // ],
                      ),
                    )
                    : Style15BottomNavBar(
                      navBarConfig: navBarConfig,
                      navBarDecoration: const NavBarDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(8),
                        border: Border(
                          top: BorderSide(
                            color: Color.fromARGB(255, 219, 219, 219),
                            width: 0.5,
                          ),
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.white,
                        //     // blurRadius: 10,
                        //   ),
                        // ],
                      ),
                    ),
          ),
    );
  }

  Widget _buildModalList(Icon iconWidget, String text, VoidCallback onPressed) {
    return ListTile(leading: iconWidget, title: Text(text), onTap: onPressed);
  }
}
