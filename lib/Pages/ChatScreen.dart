import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.white,
          backgroundColor: Colors.blue,
          strokeWidth: 4.0,
          onRefresh: () async {
            // Replace this delay with the code to be executed during refresh
            // and return a Future when code finishes execution.
            return Future<void>.delayed(const Duration(seconds: 3));
          },
          // Pull from top to show refresh indicator.
          child: ListView.builder(
            itemCount: 25,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(title: Text('Item $index'));
            },
          ),
        ),
      ),
    );
  }
}
