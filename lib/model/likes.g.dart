// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'likes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Like _$LikeFromJson(Map<String, dynamic> json) => Like(
  user: Utente.fromJson(json['user'] as Map<String, dynamic>),
  post: Post.fromJson(json['post'] as Map<String, dynamic>),
);

// Map<String, dynamic> _$LikeToJson(Like instance) => <String, dynamic>{
//       'user': instance.user,
//       'post': instance.post,
//     };
