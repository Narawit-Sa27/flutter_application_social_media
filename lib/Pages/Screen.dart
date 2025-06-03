// import 'package:flutter/material.dart';

// class DefScreen extends StatefulWidget {
//   const DefScreen({super.key});

//   @override
//   State<DefScreen> createState() => _DefScreenState();
// }

// class _DefScreenState extends State<DefScreen> {
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('RefreshIndicator Sample')),
//       body: RefreshIndicator(
//         key: _refreshIndicatorKey,
//         color: Colors.white,
//         backgroundColor: Colors.blue,
//         strokeWidth: 4.0,
//         onRefresh: () async {
//           // Replace this delay with the code to be executed during refresh
//           // and return a Future when code finishes execution.
//           return Future<void>.delayed(const Duration(seconds: 3));
//         },
//         // Pull from top to show refresh indicator.
//         child: ListView.builder(
//           itemCount: 25,
//           itemBuilder: (BuildContext context, int index) {
//             return ListTile(title: Text('Item $index'));
//           },
//         ),
//       ),
//     );
//   }
// }

// class test extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: Row(
//             children: [
//               Image.asset(
//                 'assets/social_icon.png', // ไอคอนแอป
//                 width: 24,
//                 height: 24,
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 'Commune',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(
//                 PhosphorIconsRegular.magnifyingGlass,
//                 size: 24.0,
//               ),
//               onPressed: () {},
//             ),
//             IconButton(
//               icon: Badge(
//                 label: Text("9"),
//                 padding: EdgeInsets.all(2),
//                 child: const Icon(PhosphorIconsRegular.bellSimple, size: 24.0),
//               ),
//               onPressed: () {},
//             ),
//           ],
//         ),
//         body: SafeArea(child: BottomNavigation()),
//       );
//   }
// }