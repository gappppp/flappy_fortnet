// ignore_for_file: non_constant_identifier_names

import 'package:flappy_fortnet/model/deser_json.dart';
import 'package:flappy_fortnet/model/posts.dart';
import 'package:flappy_fortnet/model/utenti.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:xml/xml.dart';

part 'likes.g.dart';

@JsonSerializable()
class Like implements DeserJson<Like> {
  Utente user;
  Post post;

  Like({required this.user, required this.post});

  static List<String> getFields() {
    List<String> userFields = Utente.getFields();
    userFields[userFields.indexOf('id')] = "id_user";

    List<String> postFields = Post.getFields();
    postFields[postFields.indexOf('id')] = "id_post";

    return [...userFields, ...postFields];
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user,
        'post': post,
      };

  @override
  String getPrelude() {
    return "like ${post.getPrelude()} di ${user.getPrelude()} ";
  }

  factory Like.fromJson(Map<String, dynamic> json) =>
      _$LikeFromJson(json); //'_' = metodo privato

  // Map<String, dynamic> toJson() => _$LikeToJson(this);
  factory Like.fromXml(XmlElement xml) => Like(
        user: Utente.fromXml(xml.getElement('user')!),
        post: Post.fromXml(xml.getElement('post')!),
      );
}
