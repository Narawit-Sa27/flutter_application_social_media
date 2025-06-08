import 'package:flutter/material.dart';

class SearchBar1 extends StatelessWidget {
  const SearchBar1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: "Search...",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),

        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: DefaultTabController(
          length: 4,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'People'),
                  Tab(text: 'Post'),
                  Tab(text: 'Reel'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Center(child: Text('All results')),
                    Center(child: Text('People results')),
                    Center(child: Text('Post results')),
                    Center(child: Text('Reel results')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
