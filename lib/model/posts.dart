// ignore_for_file: non_constant_identifier_names

import 'package:flappy_fortnet/model/deser_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:xml/xml.dart';

part 'posts.g.dart';

@JsonSerializable()
class Post implements DeserJson<Post> {
  int id;
  String title;
  String body;

  Post({required this.id, required this.title, required this.body});

  static List<String> getFields() {
    return ["id", "title", "body"];
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'body': body,
      };

  @override
  String getPrelude() {
    return "$id#$title";
  }

  factory Post.fromJson(Map<String, dynamic> json) =>
      _$PostFromJson(json); //'_' = metodo privato

  // Map<String, dynamic> toJson() => _$PostToJson(this);
  factory Post.fromXml(XmlElement xml) =>
      Post(id: int.parse(xml.getAttribute('id')!), title: xml.getElement('title')!.innerText, body: xml.getElement('body')!.innerText);
}
