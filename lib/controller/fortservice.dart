import 'dart:convert';
import 'package:flappy_fortnet/model/likes.dart';
import 'package:http/http.dart' as http;
import 'package:flappy_fortnet/model/posts.dart';
import 'package:flappy_fortnet/model/utenti.dart';

class Fortservice {
  late String _url;

  Fortservice() {
    _url = "http://localhost:80/php/fortnet.php";
  }

  Future<List<Utente>?> getUsers(Map<String, String> filters) async {
    final client = http.Client();

    String _filters = "";
    if (filters['id'] != null) {
      _filters = "$_filters&id=${filters['id']}";
    }
    if (filters['username'] != null) {
      _filters = "$_filters&username=${filters['username']}";
    }
    if (filters['password'] != null) {
      _filters = "$_filters&password=${filters['password']}";
    }

    final uri = Uri.parse("$_url/search_user?format=JSON$_filters");

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List) //GET JsonObj (array of 1 || n)
          .map((utenteJson) => Utente.fromJson(utenteJson))
          //use anonymous fn for each item now named utenteJson
          .toList(); //conver all to list
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<Utente>?> getAllUsers() async {
    final client = http.Client();
    final uri = Uri.parse("$_url/users?format=JSON");


    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List) //GET JsonObj (array of 1 || n)
          .map((utenteJson) => Utente.fromJson(utenteJson))
          //use anonymous fn for each item now named utenteJson
          .toList(); //conver all to list
    } else {
      throw Exception(res.statusCode);
    }
  }



  Future<List<Post>?> getPosts(Map<String, String> filters) async {
    final client = http.Client();

    String _filters = "";
    if (filters['id'] != null) {
      _filters = "$_filters&id=${filters['id']}";
    }
    if (filters['title'] != null) {
      _filters = "$_filters&title=${filters['title']}";
    }
    if (filters['body'] != null) {
      _filters = "$_filters&body=${filters['body']}";
    }

    final uri = Uri.parse("$_url/search_post?format=JSON$_filters");

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List) //GET JsonObj (array of 1 || n)
          .map((postJson) => Post.fromJson(postJson))
          //use anonymous fn for each item now named postJson
          .toList(); //conver all to list
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<Post>?> getAllPosts() async {
    final client = http.Client();
    final uri = Uri.parse("$_url/posts?format=JSON");

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List) //GET JsonObj (array of 1 || n)
          .map((postJson) => Post.fromJson(postJson))
          //use anonymous fn for each item now named postJson
          .toList(); //conver all to list
    } else {
      throw Exception(res.statusCode);
    }
  }



  Future<List<Like>?> getLikes(Map<String, String> filters) async {
    final client = http.Client();

    String _filters = "";
    if (filters['id_like'] != null) {
      _filters = "$_filters&id_like=${filters['id_like']}";
    }
    
    if (filters['id_user'] != null) {
      _filters = "$_filters&id_user=${filters['id_user']}";
    }
    if (filters['username'] != null) {
      _filters = "$_filters&username=${filters['username']}";
    }
    if (filters['password'] != null) {
      _filters = "$_filters&password=${filters['password']}";
    }

    if (filters['id_post'] != null) {
      _filters = "$_filters&id_post=${filters['id_post']}";
    }
    if (filters['title'] != null) {
      _filters = "$_filters&title=${filters['title']}";
    }
    if (filters['body'] != null) {
      _filters = "$_filters&body=${filters['body']}";
    }

    final uri = Uri.parse("$_url/search_like?format=JSON$_filters");

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final res = await client.get(uri, headers: headers);
    
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List) //GET JsonObj (array of 1 || n)
          .map((likeJson) => Like.fromJson(likeJson))
          //use anonymous fn for each item now named likeJson
          .toList(); //conver all to list
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<Like>?> getAllLikes() async {
    final client = http.Client();
    final uri = Uri.parse("$_url/likes?format=JSON");

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final res = await client.get(uri, headers: headers);
    
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List) //GET JsonObj (array of 1 || n)
          .map((likeJson) => Like.fromJson(likeJson))
          //use anonymous fn for each item now named likeJson
          .toList(); //conver all to list
    } else {
      throw Exception(res.statusCode);
    }
  }



  Future<List<T>> getT<T>(Map<String, String> filters) async {
    if(T == Utente) {
      return (await getUsers(filters)) as List<T>;

    } else if(T == Post) {
      return (await getPosts(filters)) as List<T>;

    } else if(T == Like) {
      return (await getLikes(filters)) as List<T>;

    }

    return List.empty();
  }

  Future<List<T>> getAllT<T>() async {
    if(T == Utente) {
      return (await getAllUsers()) as List<T>;

    } else if(T == Post) {
      return (await getAllPosts()) as List<T>;

    } else if(T == Like) {
      return (await getAllLikes()) as List<T>;

    }

    return List.empty();
  }

}