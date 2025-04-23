// ignore_for_file: non_constant_identifier_names

import 'package:flappy_fortnet/model/deser_json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'posts.g.dart';

@JsonSerializable()
class Post implements DeserJson<Post> {
  int id;
  String title;
  String body;
  
  Post({
    required this.id,
    required this.title,
    required this.body
  });

  static List<String> getFields() {
    return ["id", "title", "body"];
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'title': title,
    'body': body,
  };

    factory Post.fromJson(Map<String, dynamic> json) =>
      _$PostFromJson(json); //'_' = metodo privato

  // Map<String, dynamic> toJson() => _$PostToJson(this);
}
