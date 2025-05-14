import 'dart:convert';
import 'package:flappy_fortnet/model/global.dart';
import 'package:flappy_fortnet/model/likes.dart';
import 'package:http/http.dart' as http;
import 'package:flappy_fortnet/model/posts.dart';
import 'package:flappy_fortnet/model/utenti.dart';
import 'package:xml/xml.dart';

// Todo: fix update / patch
class Fortservice {
  late String _url;

  Fortservice() {
    _url = "http://localhost:80/php/fortnet.php";
  }

  Future<List<int>> getUsersIds() async {
    String preferedLanguage = Global().getPreferedLanguage();

    final client = http.Client();
    final uri = Uri.parse("$_url/users_ids?format=$preferedLanguage");

    Map<String, String> headers = {
      'Accept': 'application/$preferedLanguage',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return preferedLanguage == "json"
          ? (jsonDecode(res.body) as List)
              .map((map) => map['id_user']!)
              .toList()
              .cast<int>()
          : XmlDocument.parse(res.body)
              .childElements
              .first
              .childElements
              .map((e) => int.parse(e.innerText))
              .toList();
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<int>> getPostsIds() async {
    String preferedLanguage = Global().getPreferedLanguage();

    final client = http.Client();
    final uri = Uri.parse("$_url/posts_ids?format=$preferedLanguage");

    Map<String, String> headers = {
      'Accept': 'application/$preferedLanguage',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return preferedLanguage == "json"
          ? (jsonDecode(res.body) as List)
              .map((map) => map['id_post']!)
              .toList()
              .cast<int>()
          : XmlDocument.parse(res.body)
              .childElements
              .first
              .childElements
              .map((e) => int.parse(e.innerText))
              .toList();
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<Utente>?> getUsers(Map<String, String> filters) async {
    String preferedLanguage = Global().getPreferedLanguage();

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

    final uri =
        Uri.parse("$_url/search_user?format=$preferedLanguage$_filters");

    Map<String, String> headers = {
      'Accept': 'application/$preferedLanguage',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return preferedLanguage == "json"
          ? (jsonDecode(res.body) as List)
              .map((utenteJson) => Utente.fromJson(utenteJson))
              .toList()
          : XmlDocument.parse(res.body)
              .childElements
              .first
              .childElements
              .map(Utente.fromXml)
              .toList();
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<Utente>?> getAllUsers() async {
    String preferedLanguage = Global().getPreferedLanguage();

    final client = http.Client();
    final uri = Uri.parse("$_url/users?format=$preferedLanguage");

    Map<String, String> headers = {
      'Accept': 'application/$preferedLanguage',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return preferedLanguage == "json"
          ? (jsonDecode(res.body) as List)
              .map((utenteJson) => Utente.fromJson(utenteJson))
              .toList()
          : XmlDocument.parse(res.body)
              .childElements
              .first
              .childElements
              .map(Utente.fromXml)
              .toList();
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<Post>?> getPosts(Map<String, String> filters) async {
    String preferedLanguage = Global().getPreferedLanguage();

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

    final uri =
        Uri.parse("$_url/search_post?format=$preferedLanguage$_filters");

    Map<String, String> headers = {
      'Accept': 'application/$preferedLanguage',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return preferedLanguage == "json"
          ? (jsonDecode(res.body) as List)
              .map((utenteJson) => Post.fromJson(utenteJson))
              .toList()
          : XmlDocument.parse(res.body)
              .childElements
              .first
              .childElements
              .map(Post.fromXml)
              .toList();
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<Post>?> getAllPosts() async {
    String preferedLanguage = Global().getPreferedLanguage();

    final client = http.Client();
    final uri = Uri.parse("$_url/posts?format=$preferedLanguage");

    Map<String, String> headers = {
      'Accept': 'application/$preferedLanguage',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return preferedLanguage == "json"
          ? (jsonDecode(res.body) as List)
              .map((utenteJson) => Post.fromJson(utenteJson))
              .toList()
          : XmlDocument.parse(res.body)
              .childElements
              .first
              .childElements
              .map(Post.fromXml)
              .toList();
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<Like>?> getLikes(Map<String, String> filters) async {
    String preferedLanguage = Global().getPreferedLanguage();

    final client = http.Client();

    String _filters = "";

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

    final uri =
        Uri.parse("$_url/search_like?format=$preferedLanguage$_filters");

    Map<String, String> headers = {
      'Accept': 'application/$preferedLanguage',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return preferedLanguage == "json"
          ? (jsonDecode(res.body) as List)
              .map((utenteJson) => Like.fromJson(utenteJson))
              .toList()
          : XmlDocument.parse(res.body)
              .childElements
              .first
              .childElements
              .map(Like.fromXml)
              .toList();
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<Like>?> getAllLikes() async {
    String preferedLanguage = Global().getPreferedLanguage();

    final client = http.Client();
    final uri = Uri.parse("$_url/likes?format=$preferedLanguage");

    Map<String, String> headers = {
      'Accept': 'application/$preferedLanguage',
    };

    final res = await client.get(uri, headers: headers);

    if (res.statusCode == 200) {
      return preferedLanguage == "json"
          ? (jsonDecode(res.body) as List)
              .map((utenteJson) => Like.fromJson(utenteJson))
              .toList()
          : XmlDocument.parse(res.body)
              .childElements
              .first
              .childElements
              .map(Like.fromXml)
              .toList();
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<T>> getT<T>(Map<String, String> filters) async {
    if (T == Utente) {
      return (await getUsers(filters)) as List<T>;
    } else if (T == Post) {
      return (await getPosts(filters)) as List<T>;
    } else if (T == Like) {
      return (await getLikes(filters)) as List<T>;
    }

    return List.empty();
  }

  Future<List<T>> getAllT<T>() async {
    if (T == Utente) {
      return (await getAllUsers()) as List<T>;
    } else if (T == Post) {
      return (await getAllPosts()) as List<T>;
    } else if (T == Like) {
      return (await getAllLikes()) as List<T>;
    }

    return List.empty();
  }

  Future<void> createUser(Map<String, String> user) async {
    String preferedLanguage = Global().getPreferedLanguage();

    final client = http.Client();
    final uri = Uri.parse("$_url/user");

    var headers = {
      'Content-Type': 'application/$preferedLanguage',
    };

    var body = "";

    if (preferedLanguage == "json") {
      body = jsonEncode({
        'username': user['username'],
        'password': user['password'],
      });
    } else if (preferedLanguage == "xml") {
      body =
          "<user><username>${user['username']}</username><password>${user['password']}</password></user>";
    }

    final res = await client.post(uri, headers: headers, body: body);

    if (res.statusCode != 201) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> createPost(Map<String, String> post) async {
    String preferedLanguage = Global().getPreferedLanguage();
    final client = http.Client();
    final uri = Uri.parse("$_url/$preferedLanguage");

    var headers = {
      'Content-Type': 'application/$preferedLanguage',
    };

    var body = "";

    if (preferedLanguage == "json") {
      body = jsonEncode({
        'title': post['title'],
        'body': post['body'],
      });
    } else if (preferedLanguage == "xml") {
      body =
          "<post><title>${post['title']}</title><body>${post['body']}</body></post>";
    }

    final res = await client.post(uri, headers: headers, body: body);

    if (res.statusCode != 201) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> createLike(Map<String, String> like) async {
    String preferedLanguage = Global().getPreferedLanguage();

    final client = http.Client();
    final uri = Uri.parse("$_url/add_like");

    var headers = {
      'Content-Type': 'application/$preferedLanguage',
    };

    var body = "";

    if (preferedLanguage == "json") {
      body = jsonEncode({
        'id_user': like['id_user'],
        'id_post': like['id_post'],
      });
    } else if (preferedLanguage == "xml") {
      body =
          "<like><id_user>${like['id_user']}</id_user><id_post>${like['id_post']}</id_post></like>";
    }

    final res = await client.put(uri, headers: headers, body: body);

    if (res.statusCode != 201) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> createT<T>(Map<String, String> obj) async {
    if (T == Utente) {
      await createUser(obj);
    } else if (T == Post) {
      await createPost(obj);
    } else if (T == Like) {
      await createLike(obj);
    }
  }

  Future<void> updateUser(Map<String, String> user) async {
    String preferedLanguage = Global().getPreferedLanguage();

    final client = http.Client();
    final uri = Uri.parse("$_url/user");

    var headers = {
      'Content-Type': 'application/$preferedLanguage',
    };

    var body = "";

    if (preferedLanguage == "json") {
      body = jsonEncode({
        'id': user['id'],
        'username': user['username'],
        'password': user['password'],
      });
    } else if (preferedLanguage == "xml") {
      body =
          "<user id='${user['id']}'><username>${user['username']}</username><password>${user['password']}</password></user>";
    }

    final res = await client.put(uri, headers: headers, body: body);

    if (res.statusCode != 204) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> updatePost(Map<String, String> post) async {
    String preferedLanguage = Global().getPreferedLanguage();

    final client = http.Client();
    final uri = Uri.parse("$_url/post");

    var headers = {
      'Content-Type': 'application/$preferedLanguage',
    };

    var body = "";

    if (preferedLanguage == "json") {
      body = jsonEncode({
        'id': post['id'],
        'title': post['title'],
        'body': post['body'],
      });
    } else if (preferedLanguage == "xml") {
      body =
          "<post id='${post['id']}'><title>${post['title']}</title><body>${post['body']}</body></post>";
    }

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
    String preferedLanguage = Global().getPreferedLanguage();

    final client = http.Client();
    final uri = Uri.parse("$_url/user");

    var headers = {
      'Content-Type': 'application/$preferedLanguage',
    };

    var body = "";

    if (preferedLanguage == "json") {
      body = jsonEncode({
        'id': id,
      });
    } else if (preferedLanguage == "xml") {
      body = "<user><id>$id</id></user>";
    }

    final res = await client.delete(uri, headers: headers, body: body);

    if (res.statusCode != 204) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deletePost(int id) async {
    String preferedLanguage = Global().getPreferedLanguage();

    final client = http.Client();
    final uri = Uri.parse("$_url/post");

    var headers = {
      'Content-Type': 'application/$preferedLanguage',
    };

    var body = "";

    if (preferedLanguage == "json") {
      body = jsonEncode({
        'id': id,
      });
    } else if (preferedLanguage == "xml") {
      body = "<post><id>$id</id></post>";
    }

    final res = await client.delete(uri, headers: headers, body: body);

    if (res.statusCode != 204) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteLike(int firstId, int secondId) async {
    String preferedLanguage = Global().getPreferedLanguage();

    final client = http.Client();
    final uri = Uri.parse("$_url/del_like");

    var headers = {
      'Content-Type': 'application/$preferedLanguage',
    };

    var body = "";

    if (preferedLanguage == "json") {
      body = jsonEncode({
        'id_user': firstId,
        'id_post': secondId,
      });
    } else if (preferedLanguage == "xml") {
      body =
          "<like><id_user>$firstId</id_user><id_post>$secondId</id_post></like>";
    }

    final res = await client.put(uri, headers: headers, body: body);

    if (res.statusCode != 204) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteT<T>(int id, {int? secondId}) async {
    if (T == Utente) {
      await deleteUser(id);
    } else if (T == Post) {
      await deletePost(id);
    } else if (T == Like) {
      await deleteLike(id, secondId!);
    }
  }
}
