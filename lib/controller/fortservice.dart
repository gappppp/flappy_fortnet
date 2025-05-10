import 'dart:convert';
import 'package:flappy_fortnet/main.dart';
import 'package:flappy_fortnet/model/likes.dart';
import 'package:http/http.dart' as http;
import 'package:flappy_fortnet/model/posts.dart';
import 'package:flappy_fortnet/model/utenti.dart';
import 'package:xml/xml.dart';

class Fortservice {
  late String _url;

  Fortservice() {
    _url = "http://localhost:80/php/fortnet.php";
  }

  Future<List<int>> getUsersIds() async {
    final client = http.Client();
    final uri = Uri.parse("$_url/users_ids?format=$prefferedLanguage");

    Map<String, String> headers = {
      'Accept': 'application/$prefferedLanguage',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((map) => map['id_user']!).toList().cast<int>();
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<int>> getPostsIds() async {
    final client = http.Client();
    final uri = Uri.parse("$_url/posts_ids?format=$prefferedLanguage");

    Map<String, String> headers = {
      'Accept': 'application/$prefferedLanguage',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((map) => map['id_post']!).toList().cast<int>();
    } else {
      throw Exception(res.statusCode);
    }
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

    final uri = Uri.parse("$_url/search_user?format=$prefferedLanguage$_filters");

    Map<String, String> headers = {
      'Accept': 'application/$prefferedLanguage',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List) //GET JsonObj (array of 1 || n)
          .map((utenteJson) => prefferedLanguage == "json" ? Utente.fromJson(utenteJson) : Utente.fromXml(utenteJson))
          //use anonymous fn for each item now named utenteJson
          .toList(); //conver all to list
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<Utente>?> getAllUsers() async {
    final client = http.Client();
    final uri = Uri.parse("$_url/users?format=$prefferedLanguage");

    Map<String, String> headers = {
      'Accept': 'application/$prefferedLanguage',
    };

    final res = await client.get(uri, headers: headers);
    
    if (res.statusCode == 200) {
      return prefferedLanguage == "json" ?
        (jsonDecode(res.body) as List).map((utenteJson) => Utente.fromJson(utenteJson)).toList()
        :
        XmlDocument.parse(res.body).childElements.first.childElements.map(Utente.fromXml).toList();
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

    final uri = Uri.parse("$_url/search_post?format=$prefferedLanguage$_filters");

    Map<String, String> headers = {
      'Accept': 'application/$prefferedLanguage',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List) //GET JsonObj (array of 1 || n)
          .map((postJson) => prefferedLanguage == "json" ? Post.fromJson(postJson) : Post.fromXml(postJson))
          //use anonymous fn for each item now named postJson
          .toList(); //conver all to list
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<Post>?> getAllPosts() async {
    final client = http.Client();
    final uri = Uri.parse("$_url/posts?format=$prefferedLanguage");

    Map<String, String> headers = {
      'Accept': 'application/$prefferedLanguage',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List) //GET JsonObj (array of 1 || n)
          .map((postJson) => prefferedLanguage == "json" ? Post.fromJson(postJson) : Post.fromXml(postJson))
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

    final uri = Uri.parse("$_url/search_like?format=$prefferedLanguage$_filters");

    Map<String, String> headers = {
      'Accept': 'application/$prefferedLanguage',
    };

    final res = await client.get(uri, headers: headers);
    
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List) //GET JsonObj (array of 1 || n)
          .map((likeJson) => prefferedLanguage == "json" ? Like.fromJson(likeJson) : Like.fromXml(likeJson))
          //use anonymous fn for each item now named likeJson
          .toList(); //conver all to list
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<Like>?> getAllLikes() async {
    final client = http.Client();
    final uri = Uri.parse("$_url/likes?format=$prefferedLanguage");

    Map<String, String> headers = {
      'Accept': 'application/$prefferedLanguage',
    };

    final res = await client.get(uri, headers: headers);
    
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List) //GET JsonObj (array of 1 || n)
          .map((likeJson) => prefferedLanguage == "json" ? Like.fromJson(likeJson) : Like.fromXml(likeJson))
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

  Future<void> createUser(Map<String, String> user) async {
    final client = http.Client();
    final uri = Uri.parse("$_url/user");

    var headers = {
      'Content-Type': 'application/$prefferedLanguage',
    };

    var body = "";

    if (prefferedLanguage == "json") {
      body = jsonEncode({
        'username': user['username'],
        'password': user['password'],
      });
    } else if (prefferedLanguage == "xml") {
      body = "<user><username>${user['username']}</username><password>${user['password']}</password></user>";
    }

    final res = await client.post(uri, headers: headers, body: body);
    
    if (res.statusCode != 201) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> createPost(Map<String, String> post) async {
    final client = http.Client();
    final uri = Uri.parse("$_url/$prefferedLanguage");

    var headers = {
      'Content-Type': 'application/$prefferedLanguage',
    };

    var body = jsonEncode({
      'title': post['title'],
      'body': post['body'],
    });

    final res = await client.post(uri, headers: headers, body: body);
    
    if (res.statusCode != 201) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> createLike(Map<String, String> like) async {
    final client = http.Client();
    final uri = Uri.parse("$_url/add_like");

    var headers = {
      'Content-Type': 'application/$prefferedLanguage',
    };

    var body = jsonEncode({
      'id_user': like['id_user'],
      'id_post': like['id_post'],
    });

    final res = await client.put(uri, headers: headers, body: body);
    
    if (res.statusCode != 201) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> createT<T>(Map<String, String> obj) async {
    if(T == Utente) {
      await createUser(obj);
    } else if(T == Post) {
      await createPost(obj);
    } else if(T == Like) {
      await createLike(obj);
    }
  }

  Future<void> updateUser(Map<String, String> user) async {
    final client = http.Client();
    final uri = Uri.parse("$_url/user");

    var headers = {
      'Content-Type': 'application/$prefferedLanguage',
    };

    var body = jsonEncode({
      'id': user['id'],
      'username': user['username'],
      'password': user['password'],
    });

    final res = await client.put(uri, headers: headers, body: body);
    
    if (res.statusCode != 204) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> updatePost(Map<String, String> post) async {
    final client = http.Client();
    final uri = Uri.parse("$_url/post");

    var headers = {
      'Content-Type': 'application/$prefferedLanguage',
    };

    var body = jsonEncode({
      'id': post['id'],
      'title': post['title'],
      'body': post['body'],
    });

    final res = await client.put(uri, headers: headers, body: body);
    
    if (res.statusCode != 204) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> updateT<T>(Map<String, String> obj) async {
    if (T == Utente) {
      await updateUser(obj);
    } else if (T == Post) {
      await updatePost(obj);
    }
  }

  Future<void> deleteUser(int id) async {
    final client = http.Client();
    final uri = Uri.parse("$_url/user");

    var headers = {
      'Content-Type': 'application/$prefferedLanguage',
    };

    var body = jsonEncode({
      'id': id,
    });

    final res = await client.delete(uri, headers: headers, body: body);
    
    if (res.statusCode != 204) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deletePost(int id) async {
    final client = http.Client();
    final uri = Uri.parse("$_url/post");

    var headers = {
      'Content-Type': 'application/$prefferedLanguage',
    };

    var body = jsonEncode({
      'id': id,
    });

    final res = await client.delete(uri, headers: headers, body: body);
    
    if (res.statusCode != 204) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteLike(int firstId, int secondId) async {
    final client = http.Client();
    final uri = Uri.parse("$_url/del_like");

    var headers = {
      'Content-Type': 'application/$prefferedLanguage',
    };

    var body = jsonEncode({
      'id_user': firstId,
      'id_post': secondId,
    });

    final res = await client.put(uri, headers: headers, body: body);
    
    if (res.statusCode != 204) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteT<T>(int id, {int? secondId}) async {
    if(T == Utente) {
      await deleteUser(id);
    } else if(T == Post) {
      await deletePost(id);
    } else if(T == Like) {
      await deleteLike(id, secondId!);
    }
  }
}