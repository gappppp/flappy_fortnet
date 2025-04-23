import 'package:flutter/material.dart';

class SimpleMenuScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final _currentRoute = ModalRoute.of(context)?.settings.name;
    final currentRoute = _currentRoute!.endsWith('/') ? _currentRoute : '$_currentRoute/';

    return Scaffold(
      appBar:
        AppBar(title: Center(child: Text(title))),
      body:
        Column(
          children: [
            const Text("Scegli un opzione"),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, i) {
                  final entry = options.entries.elementAt(i);
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