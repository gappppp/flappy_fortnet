// import 'package:flutter/material.dart';
// import 'package:flappy_fortnet/controller/fortservice.dart';
// import 'package:flappy_fortnet/model/posts.dart';

// class PostsScreen extends StatefulWidget {
//   const PostsScreen({super.key});

//   @override
//   _PostsScreenState createState() => _PostsScreenState();
// }

// class _PostsScreenState extends State<PostsScreen> {
//   List<Post>? posts;
//   bool isLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     loadPosts();
//   }

//   Future<void> loadPosts() async {
//     // Simulazione di caricamento dati. Usa SchoolService nel caso reale.
//     posts = await Fortservice().getAllPosts();

//     setState(() {
//       isLoaded = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Center(child: Text('Posts'))),
//       body: isLoaded && posts != null ?
//       ListView.builder(
//         itemCount: posts!.length,
//         itemBuilder: (context, index) {
//           final post = posts![index];
//           return ListTile(
//             title: Text(post.title),
//             subtitle: Text('ID: ${post.id}'),
//           );
//         },
//       )
//       :
//       const Center(child: CircularProgressIndicator()),
//     );
//   }
// }
