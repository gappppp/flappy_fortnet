import 'package:flappy_fortnet/model/global.dart';
import 'package:flappy_fortnet/model/likes.dart';
import 'package:flappy_fortnet/model/posts.dart';
import 'package:flappy_fortnet/model/route_tracker.dart';
import 'package:flappy_fortnet/model/utenti.dart';
import 'package:flappy_fortnet/view/auth_screen.dart';
import 'package:flappy_fortnet/view/create_screen.dart';
import 'package:flappy_fortnet/view/delete_screen.dart';
import 'package:flappy_fortnet/view/error_screen.dart';
import 'package:flappy_fortnet/view/simple_menu_screen.dart';
import 'package:flappy_fortnet/view/read_screen.dart';
import 'package:flappy_fortnet/view/update_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final Map<String, WidgetBuilder> protectedRoutes = {
    '/': (context) => SimpleMenuScreen(
      title: "Home",
      menuDesc: "Scegli un opzione",
      options: Map.from(<String, String>{
        "users": "Gestisci gli utenti",
        "posts": "Gestisci i posts",
        "likes": "Gestisci i likes"
      })
    ),
      '/users': (context) => SimpleMenuScreen(
          title: "Utenti",
          menuDesc: "Scegli un opzione",
          options: Map.from(<String, String>{
            "read": "Visualizza gli utenti",
            "create": "Aggiungi un utente",
            "update": "Modifica un utente",
            "delete": "Elimina un utente"
          })
      ),
        '/users/read': (context) => const ReadScreen<Utente>(),
        '/users/create': (context) => const CreateScreen<Utente>(),
        '/users/update': (context) => const UpdateScreen<Utente>(),
        '/users/delete': (context) => const DeleteScreen<Utente>(),

      '/posts': (context) => SimpleMenuScreen(
        title: "Posts",
        menuDesc: "Scegli un opzione",
        options: Map.from(<String, String>{
          "read": "Visualizza i posts",
          "create": "Aggiungi un post",
          "update": "Modifica un post",
          "delete": "Elimina un post"
      })),
        '/posts/read': (context) => const ReadScreen<Post>(), 
        '/posts/create': (context) => const CreateScreen<Post>(), 
        '/posts/update': (context) => const UpdateScreen<Post>(), 
        '/posts/delete': (context) => const DeleteScreen<Post>(), 

      '/likes': (context) => SimpleMenuScreen(
        title: "Likes",
        menuDesc: "Scegli un opzione",
        options: Map.from(<String, String>{
          "read": "Visualizza i likes",
          "create": "Aggiungi un like",
          "delete": "Elimina un like"
      })),
        '/likes/read': (context) => const ReadScreen<Like>(), 
        '/likes/create': (context) => const CreateScreen<Like>(),
        '/likes/delete': (context) => const DeleteScreen<Like>(), 
  };


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

      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthScreen(),
      },

      navigatorObservers: [RouteTracker()],

      onGenerateRoute: (settings) {//when new route request
        //return to /auth if not authorized
        if (!Global().possesToken()) {
          return MaterialPageRoute(
            settings: RouteSettings(name: settings.name),//set name otherwise it remains the prev route name
            builder: (_) => const AuthScreen()
          );
        } else {
          return MaterialPageRoute(
            settings: RouteSettings(name: settings.name),//set name otherwise it remains the prev route name
            builder:
              protectedRoutes[settings.name]
              ?? (_) => const ErrorScreen(
                errorCode: 404,
                header: "Pagina richiesta inesistente",
                body: "La pagina richiesta non esiste"
              )
          );
        }
      }
    );
  }
}
