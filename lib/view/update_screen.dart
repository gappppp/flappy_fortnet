import 'package:flappy_fortnet/controller/fortservice.dart';
import 'package:flappy_fortnet/model/deser_json.dart';
import 'package:flappy_fortnet/model/global.dart';
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
    if (!Global().isTokenValid()) {
      Navigator.popUntil(context, ModalRoute.withName("/"));
    } else {
      super.initState();
      loadT();
    }
    
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
                          int fieldAffected = 0;

                          for (var i = 0; i < fields.length; i++) {
                            if (controllers[i].text != "") {
                              data[fields[i]] = controllers[i].text;
                              if (i > 0) fieldAffected++;
                            }
                          }
                          // Call the async function *before* setState
                          if(fieldAffected > 0) {
                            if (fieldAffected == fields.length-1) {
                              await Fortservice().updateT<T>(data);
                            } else {
                              await Fortservice().patchT<T>(data);
                            }
                            
                            // trigger reload
                            for (var controller in controllers) {
                              controller.clear();
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Aggiornamento avvenuto con successo!"),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(
                              "Errore: ${e == 500 ? "Impossibile creare la risorsa" : e.toString()}"
                            ))
                          );
                        }
                      },
                      child: Text(title),
                    ),
                  ),
                ],
              )
            ],
          )
        )
        :
        const Center(child: CircularProgressIndicator()),
    );
  }
}