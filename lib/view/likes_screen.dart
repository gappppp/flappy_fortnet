// import 'package:flutter/material.dart';
// import 'package:flappy_fortnet/controller/fortservice.dart';
// import 'package:flappy_fortnet/model/likes.dart';

// class LikesScreen extends StatefulWidget {
//   const LikesScreen({super.key});

//   @override
//   _LikesScreenState createState() => _LikesScreenState();
// }

// class _LikesScreenState extends State<LikesScreen> {
//   List<Like>? likes;
//   bool isLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     loadLikes();
//   }

//   Future<void> loadLikes() async {
//     // Simulazione di caricamento dati. Usa SchoolService nel caso reale.
//     likes = await Fortservice().getAllLikes();
//     setState(() {
//       isLoaded = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Center(child: Text('Likes'))),
//       body: isLoaded && likes != null ?
//       ListView.builder(
//         itemCount: likes!.length,
//         itemBuilder: (context, index) {
//           final like = likes![index];
//           return ListTile(
            
//             title: Text(like.post.title),
//             subtitle: Text("FROM: ${like.user.username}"),
//             // title: RichText(
//             //   text: TextSpan(
//             //     style: DefaultTextStyle.of(context).style,
//             //     children: [
//             //       TextSpan(
//             //         text: like.user.username,
//             //         style: TextStyle(
//             //           fontFamily: 'monospace',
//             //           backgroundColor: Colors.grey.shade200,
//             //         ),
//             //       ),
//             //       const TextSpan(
//             //         text: ' ha messo like a ', 
//             //         style: TextStyle(
//             //           fontWeight: FontWeight.w100
//             //         )
//             //       ),
//             //       TextSpan(
//             //         text: like.post.title,
//             //         style: TextStyle(
//             //           fontFamily: 'monospace',
//             //           backgroundColor: Colors.grey.shade200,
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // )
//             //
//           );
//         },
//       )
//       :
//       const Center(child: CircularProgressIndicator()),
//     );
//   }
// }
