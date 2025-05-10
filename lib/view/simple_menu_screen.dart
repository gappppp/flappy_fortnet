import 'package:flappy_fortnet/main.dart';
import 'package:flutter/material.dart';

class SimpleMenuScreen extends StatefulWidget {
  const SimpleMenuScreen({
    super.key,
    required this.title,
    required this.menuDesc,
    required this.options,
  });

  final String title;
  final String menuDesc;
  final Map<String, String> options;

  @override
  State<SimpleMenuScreen> createState() => _SimpleMenuScreen();
}

class _SimpleMenuScreen extends State<SimpleMenuScreen> {
  var _prefferedLanguage = "json";

  void changeLanguage() {
    setState(() {
      _prefferedLanguage = _prefferedLanguage == "json" ? "xml" : "json";
    });

    prefferedLanguage = _prefferedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final _currentRoute = ModalRoute.of(context)?.settings.name;
    final currentRoute = _currentRoute!.endsWith('/') ? _currentRoute : '$_currentRoute/';

    IconData icon = _prefferedLanguage == "json" ? Icons.data_object : Icons.code;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        // leading: IconButton (
        //   icon: Icon(Icons.arrow_back), 
        //   onPressed: () { 
        //     /** Do something */ 
        //   },
        // ),
        actions: [
          IconButton(
            icon: Icon(icon),
            onPressed: () {
              changeLanguage();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Lingua dei dati cambiata in $_prefferedLanguage"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: "Json/XML",
          ),
        ],
      ),
      body:
        Column(
          children: [
            const Text("Scegli un opzione"),
            Expanded(
              child: ListView.builder(
                itemCount: widget.options.length,
                itemBuilder: (context, i) {
                  final entry = widget.options.entries.elementAt(i);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '$currentRoute${entry.key}');
                      },
                      child: Text(entry.value),
                    ),
                  );
                },
              )
            )
          ],
        )
    );
  }
}