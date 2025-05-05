import 'package:flappy_fortnet/model/likes.dart';
import 'package:flappy_fortnet/model/posts.dart';
import 'package:flappy_fortnet/model/utenti.dart';
import 'package:flappy_fortnet/view/dummy_screen.dart';
import 'package:flappy_fortnet/view/simple_menu_screen.dart';
import 'package:flappy_fortnet/view/read_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,

      // initialRoute: '/',
      routes: {
        '/': (context) => SimpleMenuScreen(
            title: "Home",
            menuDesc: "Scegli un opzione",
            options: Map.from(<String, String>{
              "users": "Gestisci gli utenti",
              "posts": "Gestisci i posts",
              "likes": "Gestisci i likes"
            })),
        '/users': (context) => SimpleMenuScreen(
            title: "Utenti",
            menuDesc: "Scegli un opzione",
            options: Map.from(<String, String>{
              "read": "Visualizza gli utenti",
              "create": "Aggiungi un utente",
              "update": "Modifica un utente",
              "delete": "Elimina un utente"
            })),
        '/users/read': (context) => const ReadScreen<Utente>(),
        '/users/create': (context) => const DummyScreen(), //todo
        '/users/update': (context) => const DummyScreen(), //todo
        '/users/delete': (context) => const DummyScreen(), //todo

        '/posts': (context) => SimpleMenuScreen(
            title: "Posts",
            menuDesc: "Scegli un opzione",
            options: Map.from(<String, String>{
              "read": "Visualizza i posts",
              "create": "Aggiungi un post",
              "update": "Modifica un post",
              "delete": "Elimina un post"
            })),
        '/posts/read': (context) => const ReadScreen<Post>(), //todo
        '/posts/create': (context) => const DummyScreen(), //todo
        '/posts/update': (context) => const DummyScreen(), //todo
        '/posts/delete': (context) => const DummyScreen(), //todo

        '/likes': (context) => SimpleMenuScreen(
            title: "Likes",
            menuDesc: "Scegli un opzione",
            options: Map.from(<String, String>{
              "read": "Visualizza i likes",
              "create": "Aggiungi un like",
              "update": "Modifica un like",
              "delete": "Elimina un like"
            })),
        '/likes/read': (context) => const ReadScreen<Like>(), //todo
        '/likes/create': (context) => const DummyScreen(), //todo
        '/likes/update': (context) => const DummyScreen(), //todo
        '/likes/delete': (context) => const DummyScreen(), //todo
      },
    );
  }
}
