// ignore_for_file: non_constant_identifier_names

import 'package:flappy_fortnet/model/deser_json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'utenti.g.dart';

@JsonSerializable()
class Utente implements DeserJson<Utente> {
  int id;
  String username;
  String password;

  Utente ({
    required this.id,
    required this.username,
    required this.password
  });

  static List<String> getFields() {
    return ["id", "username", "password"];
  }
  
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'username': username,
    'password': password,
  };

    factory Utente.fromJson(Map<String, dynamic> json) =>
      _$UtenteFromJson(json); //'_' = metodo privato

  // Map<String, dynamic> toJson() => _$UtenteToJson(this);
}
