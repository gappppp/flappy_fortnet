import 'package:flappy_fortnet/controller/fortservice.dart';
import 'package:flappy_fortnet/model/deser_json.dart';
import 'package:flappy_fortnet/model/likes.dart';
import 'package:flutter/material.dart';

class DeleteScreen<T extends DeserJson> extends StatefulWidget {
  const DeleteScreen({super.key});

  @override
  _DeleteScreenState<T> createState() => _DeleteScreenState<T>();
}

class _DeleteScreenState<T extends DeserJson> extends State<DeleteScreen<T>> {
  String title = "Elimina $T";

  TextEditingController idInputController = TextEditingController();
  TextEditingController secondIdInputController = TextEditingController();

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

              Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: idInputController,
                          decoration: InputDecoration(
                            labelText: T == Like ? "Id utente" : "Id",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),

                      if (T == Like) const SizedBox(width: 8),

                      if (T == Like)
                        Expanded(
                          child: TextField(
                            controller: secondIdInputController,
                            decoration: const InputDecoration(
                              labelText: "Id post",
                              border: OutlineInputBorder(),
                            ),
                          ),
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
                              await Fortservice().deleteT<T>(int.parse(idInputController.text), secondId: T == Like ? int.parse(secondIdInputController.text) : null);
                              idInputController.clear();
                              secondIdInputController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Eliminato con successo!")),
                              );
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
              ),
            ],
          ),
        )
        :
        const Center(child: CircularProgressIndicator()),
    );
  }
}