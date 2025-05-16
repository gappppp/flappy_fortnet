import 'package:flappy_fortnet/model/global.dart';
import 'package:flappy_fortnet/model/route_tracker.dart';
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
  var globalVars = Global();
  

  void changeLanguage() {
    setState(() {
      globalVars.changePreferedLanguage();
    });
  }

  void logout() {
    setState(() {
      globalVars.logout();
    });
    // Navigator.pop(context);
    Navigator.pushReplacementNamed(context, RouteTracker().getCurrentRoute());
  }

  @override
  Widget build(BuildContext context) {
    // final _currentRoute = ModalRoute.of(context)?.settings.name;
    final String _currentRoute = RouteTracker().getCurrentRoute();
    final currentRoute = _currentRoute.endsWith('/') ? _currentRoute : '$_currentRoute/';
    
    IconData langIcon = globalVars.getPreferedLanguage() == "json" ? Icons.data_object : Icons.code;
    IconData logoutIcon = Icons.logout;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text((_currentRoute == "/" ? "FortNet " : "") + widget.title)),
        //hide if route is "/" the back button
        leading: (_currentRoute == "/") ? const SizedBox.shrink() : const BackButton(),
        actions: [
          IconButton(
            icon: Icon(langIcon),
            onPressed: () {
              changeLanguage();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Lingua dei dati cambiata in ${globalVars.getPreferedLanguage()}"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: "Json/XML",
          ),

          if (_currentRoute == "/") IconButton(
            icon: Icon(logoutIcon),
            onPressed: () {
              logout();
            },
            tooltip: "Logout",
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