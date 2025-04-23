// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late Map<String, String> indexes;
//   bool isLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     loadHome();
//   }

//   Future<void> loadHome() async {
//     //N.B.: keys are the name of the router paths, values are name of the UI 
//     indexes = Map.from(<String, String>{
//       "users": "Gestisci gli utenti",
//       "posts": "Gestisci i posts",
//       "likes": "Gestisci i likes"});

//     setState(() {
//       isLoaded = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//         AppBar(title: const Center(child: Text('Home'))),
//       body:
//         Column(
//           children: [
//             const Text("Scegli un opzione"),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: indexes.length,
//                 itemBuilder: (context, i) {
//                   final entry = indexes.entries.elementAt(i);
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/${entry.key}');
//                       },
//                       child: Text(entry.value),
//                     ),
//                   );
//                 },
//               )
//             )
//           ],
//         )
//     );
//   }
// }