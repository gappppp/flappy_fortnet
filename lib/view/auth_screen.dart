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
  TextEditingController usernameInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Center(child: Text("Autentificazione")),
      // ),
      body:
        Column(
          children: [
            const Text(
              "Benvenuto su FortNet",
              textScaler: TextScaler.linear(2),
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 32), //
            

            const Text(
              "Autentificazione",
              textScaler: TextScaler.linear(1.5)
            ),

            const SizedBox(height: 12), //

            const Text("Inserisci le credenziali per proseguire"),

            const SizedBox(height: 12), //

            Row(
              children: [
                Expanded(child: TextField(
                  controller: usernameInputController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                )),

                const VerticalDivider(width: 3),//

                Expanded(child: TextField(
                  controller: passwordInputController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                )),

                const VerticalDivider(width: 3),//

                ElevatedButton(//SAVE BTN
                  onPressed: () async {
                    if (usernameInputController.text != "" && passwordInputController.text != "") {
                      try {
                        final String token = await Fortservice().createSSO(
                          usernameInputController.text, 
                          passwordInputController.text
                        );
                        print("token : $token");

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Login effettuato con successo!")),
                        );

                        setState(() {
                          globalVars.setToken(token);
                        });

                        Navigator.pushReplacementNamed(context, '/');

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