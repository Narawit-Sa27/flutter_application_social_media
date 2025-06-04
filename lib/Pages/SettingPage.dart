import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

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
          title: Text(
            "Settings and privacy",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            _buildListSetting(
              Icon(PhosphorIconsRegular.bellSimple),
              "Notification Settings",
              Icon(PhosphorIconsRegular.caretRight),
              () {},
            ),
            _buildListSetting(
              Icon(PhosphorIconsRegular.key),
              "Password Manage",
              Icon(PhosphorIconsRegular.caretRight),
              () {},
            ),
            _buildListSetting(
              Icon(PhosphorIconsRegular.info),
              "Help Center",
              Icon(PhosphorIconsRegular.caretRight),
              () {},
            ),
            _buildListSetting(
              Icon(PhosphorIconsRegular.lockKey),
              "Privacy Policy",
              Icon(PhosphorIconsRegular.caretRight),
              () {},
            ),
            _buildListSetting(
              Icon(PhosphorIconsRegular.userPlus),
              "Invites Friends",
              Icon(PhosphorIconsRegular.caretRight),
              () {},
            ),
            _buildListSetting(
              Icon(PhosphorIconsRegular.signOut),
              "Log out",
              Icon(PhosphorIconsRegular.caretRight),
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSetting(
    Widget iconStart,
    String text,
    Widget iconEnd,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFE0E0E0))),
      ),
      child: ListTile(
        // isThreeLine: true,
        leading: Container(child: iconStart),
        title: Text(text, style: TextStyle(fontSize: 20)),
        trailing: iconEnd,
        onTap: onPressed,
      ),
    );
  }
}
