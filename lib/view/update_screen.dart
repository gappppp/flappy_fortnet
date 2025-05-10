import 'package:flappy_fortnet/controller/fortservice.dart';
import 'package:flappy_fortnet/model/deser_json.dart';
import 'package:flappy_fortnet/model/posts.dart';
import 'package:flappy_fortnet/model/utenti.dart';
import 'package:flutter/material.dart';

class UpdateScreen<T extends DeserJson> extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  _UpdateScreenState<T> createState() => _UpdateScreenState<T>();
}

class _UpdateScreenState<T extends DeserJson> extends State<UpdateScreen<T>> {
  String title = "Aggiorna $T";

  List<String> fields = [];
  List<TextEditingController> controllers = [];

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadT();
  }

  Future<void> loadT() async {
    if (T == Utente) {
      title = "Aggiorna Utente";
      fields = Utente.getFields();
      controllers = List.generate(fields.length, (index) => TextEditingController());
    } else if (T == Post) {
      title = "Aggiorna Post";
      fields = Post.getFields();
      controllers = List.generate(fields.length, (index) => TextEditingController());
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

              for (var field in fields)
                Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controllers[fields.indexOf(field)],
                            decoration: InputDecoration(
                              labelText: field,
                              border: const OutlineInputBorder(),
                            ),
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
                    child: ElevatedButton(//SAVE BTN
                      onPressed: () async {
                        try {
                          Map<String, String> data = {};

                          for (var i = 0; i < fields.length; i++) {
                            data[fields[i]] = controllers[i].text;
                          }

                          // Call the async function *before* setState
                          await Fortservice().updateT<T>(data);

                          // trigger reload
                          for (var controller in controllers) {
                            controller.clear();
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Aggiornamento avvenuto con successo!"),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Errore: $e"),
                            ),
                          );
                        }
                      },
                      child: Text(title),
                    ),
                  ),
                ],
              )

              // Row(
              //   children: [
              //     ElevatedButton(//SAVE BTN
              //       onPressed: () async {
              //         if (inputController.text != "") {
              //           savedFilters[selectedFilter] = inputController.text;
              //           inputController.clear();

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