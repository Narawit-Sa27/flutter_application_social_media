import 'package:flutter/material.dart';

class SearchBar2 extends StatelessWidget {
  const SearchBar2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const TextField(
          decoration: InputDecoration(
            hintText: "Search People...",
            border: InputBorder.none,
          ),
          autofocus: true,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: const [
          ListTile(title: Text("User A")),
          ListTile(title: Text("User B")),
          ListTile(title: Text("User C")),
        ],
      ),
    );
  }
}
