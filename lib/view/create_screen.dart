import 'package:flappy_fortnet/model/deser_json.dart';
import 'package:flappy_fortnet/model/global.dart';
import 'package:flappy_fortnet/model/likes.dart';
import 'package:flappy_fortnet/model/posts.dart';
import 'package:flappy_fortnet/view/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flappy_fortnet/controller/fortservice.dart';
import 'package:flappy_fortnet/model/utenti.dart';

class CreateScreen<T extends DeserJson> extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  _CreateScreenState<T> createState() => _CreateScreenState<T>();
}

class _CreateScreenState<T extends DeserJson> extends State<CreateScreen<T>> {
  String title = "Crea $T";

  List<String> fields = [];
  List<TextEditingController> controllers = [];
  List<String> idsRelationship = [];
  List<int> firstIds = [];
  List<int> secondIds = [];

  bool isLoaded = false;

  @override
  void initState() {
    // if (!Global().isTokenValid()) {
    //   Navigator.popUntil(context, ModalRoute.withName("/"));
    // } else {
      super.initState();
      loadT();
    // }
  }

  Future<void> loadT() async {
    if(T == Utente) {
      fields = Utente.getFields();
      fields.removeAt(0);
      controllers = List.generate(fields.length, (_) => TextEditingController());
    } else if (T == Post) {
      fields = Post.getFields();
      fields.removeAt(0);
      controllers = List.generate(fields.length, (_) => TextEditingController());
    } else if (T == Like) {
      try {
        firstIds = await Fortservice().getUsersIds();
        secondIds = await Fortservice().getPostsIds();
      } catch (e) {
        ErrorScreen(errorCode: 234, header: "Errore nel reperimento dei dati", body: e.toString());
      }
      idsRelationship = [firstIds[0].toString(), secondIds[0].toString()];
    } else {
      title = "Errore";
    }

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: isLoaded ?
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Text(title),
                ],
              ),

              const SizedBox(width: 8),
              
              if (T == Like)
                Row(
                  children: [
                    Expanded(child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: idsRelationship[0],
                        onChanged: (String? newValue) {
                          setState(() {
                            idsRelationship[0] = newValue!;
                          });
                        },
                        items: firstIds.map<DropdownMenuItem<String>>((int value) {
                          return DropdownMenuItem<String>(
                            value: "$value",
                            child: Text("$value"),
                          );
                        }).toList(),
                      ),
                    ),),
                    Expanded(child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: idsRelationship[1],
                        onChanged: (String? newValue) {
                          setState(() {
                            idsRelationship[1] = newValue!;
                          });
                        },
                        items: secondIds.map<DropdownMenuItem<String>>((int value) {
                          return DropdownMenuItem<String>(
                            value: "$value",
                            child: Text("$value"),
                          );
                        }).toList(),
                      ),
                    ),),
                  ],
                ),

              for (var field in fields)
                Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: field,
                              border: const OutlineInputBorder(),
                            ),
                            controller: controllers[fields.indexOf(field)],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          Map<String, String> data = {};

                          if (T != Like) {
                            for (var field in fields) {
                              data[field] = controllers[fields.indexOf(field)].text;
                            }
                          } else {
                            data = <String, String>{
                              "id_user": idsRelationship[0],
                              "id_post": idsRelationship[1]
                            };
                          }
                          
                          Fortservice().createT<T>(data);

                          for (var controller in controllers) {
                            controller.clear();
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Creato!"))
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(
                              "Errore: ${e == 500 ? "Impossibile creare la risorsa" : e.toString()}"
                            ))
                          );
                        }
                      },
                      child: const Text("Crea")
                    ),
                  ),
                ],
              ),

              // Row(
              //   children: [
              //     ElevatedButton(//SAVE BTN
              //       onPressed: () async {

              //           // Call the async function *before* setState
              //           List<T> newList = await Fortservice().getT(savedFilters);

              //           // trigger reload
              //           setState(() {
              //             list = newList;
              //           });
              //         }
              //       },
              //       child: const Text('Salva filtro'),
              //     ),

              //     const SizedBox(width: 8),//space

              //     ElevatedButton(//RESET BTN
              //       onPressed: () async {
              //         List<T> newList = await Fortservice().getAllT();

              //         // trigger reload
              //         setState(() {
              //           list = newList;
              //           savedFilters.clear();
              //         });
              //       },
              //       child: const Text('Reset dei filtri'),
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 8),//space

              // Row(
              //   children: [
              //     Text(savedFilters_str),
              //   ],
              // ),

              // const SizedBox(height: 8),//space
              
              // list!.isNotEmpty ?
              // Expanded(child: ListView.builder(//list of Ts
              //   itemCount: list!.length,
              //   itemBuilder: (context, index) {
              //     final element = list![index];

              //     return Padding(
              //       padding: const EdgeInsets.only(bottom: 8),
              //       child: ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           padding: EdgeInsets.zero,
              //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              //           elevation: 2,
              //         ),
              //         onPressed: () async {
              //         List<T> newList = await Fortservice().getT(//get specified T
              //           Map.from(<String, String>{ filters[0]: element.toJson()[filters[0]].toString() })
              //         );
                      
              //         //todo: show specific of T


              //         // trigger reload
              //         setState(() {
              //           list = newList;
              //           savedFilters.clear();
              //         });
              //       },
              //         child: listTileOf<T>(list![index]),
              //       )
              //     );
              //   },
              // ))
              // :
              // (
              //   savedFilters.isEmpty ?
              //     Text("Nessun $T registrato nel DataBase!")
              //     :
              //     Text("Nessun $T trovato con questi criteri di ricerca!")
              // )
            ],
          )
        )
        :
        const Center(child: CircularProgressIndicator()),
    );
  }
}

ListTile listTileOf<T>(T entry) {
  if(T == Utente) {
    Utente u = entry as Utente;
    return ListTile(
      title: Text(u.username),
      subtitle: Text('ID: ${u.id}'),
    );

  } else if(T == Post) {
  Post p = entry as Post;
    return ListTile(
      title: Text(p.title),
      subtitle: Text('ID: ${p.id}'),
    );

  } else if(T == Like) {
    Like l = entry as Like;
    return ListTile(
      title: Text(l.post.title),
      subtitle: Text("FROM: ${l.user.username}"),
    );
  }

  return ListTile(
    title: Text(entry.toString()),
  );
}

/*
Expanded(child: ListView.builder(//list of Ts
            itemCount: list!.length,
            itemBuilder: (context, index) {
              return listTileOf<T>(list![index]);
            },
          ))
*/