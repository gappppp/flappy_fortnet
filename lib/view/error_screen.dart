import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.errorCode, required this.header, required this.body});

  const ErrorScreen.detailed({Key? key, required errorCode, required header, required body}) :
    this(key: key, errorCode: errorCode, header: header, body: body);

  ErrorScreen.auto({super.key, required this.errorCode, required this.header}) :
    body = switchError(errorCode);

  final int errorCode;
  final String header, body;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          Center(child: Text(//header
            header,
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(2.0),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red
              ),
          )),

          const SizedBox(width: 8),//space

          Center(child: Text(//body
            body,
            textAlign: TextAlign.center,
          )),

        ],
      )
    );
  }
}

String switchError(int errorCode) {
  switch (errorCode) {
    case 400:
      return "La richiesta è mal strutturata e/o presenta errori";
    case 404:
      return "L'operazione richiesta non è disponibile";
    case 405:
      return "Il metodo utilizzato non è supportato";
    case 500:
      return "Errore anomalo del server";
    default:
      return "Errore sconosciuto";
  }
}