import 'package:flappy_fortnet/controller/fortservice.dart';
import 'package:flappy_fortnet/model/global.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Global globalVars = Global();
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Autentificazione")),
      ),
      body:
        Column(
          children: [
            const Text("Inserisci il token di autentificazione per proseguire"),

            const SizedBox(width: 8), //

            Row(
              children: [
                Expanded(child: TextField(
                  controller: inputController,
                  decoration: const InputDecoration(
                    labelText: "Token d'accesso",
                    border: OutlineInputBorder(),
                  ),
                )),

                ElevatedButton(//SAVE BTN
                  onPressed: () async {
                    if (inputController.text != "") {
                      try {
                        final bool isValidSSO = await Fortservice().isValidSSO(inputController.text);

                        if (isValidSSO) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login effettuato con successo!")),
                          );

                          setState(() {
                            globalVars.setToken(inputController.text);
                          });
                          Navigator.popAndPushNamed(context, "/home");

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Tentativo di login fallito!")),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                            "Errore: ${e == 500 ? "Errore durante l'autenticazione" : e.toString()}"
                          ))
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Errore: Errore durante l'autenticazione"))
                      );
                    }
                  },
                  child: const Text("Invia"),
                )
              ],
            )
          ],
        )
    );
  }
}