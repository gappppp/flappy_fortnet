import 'package:flappy_fortnet/model/deser_json.dart';
import 'package:flappy_fortnet/model/global.dart';
import 'package:flappy_fortnet/model/likes.dart';
import 'package:flappy_fortnet/model/posts.dart';
import 'package:flappy_fortnet/view/detailed_view_table.dart';
import 'package:flappy_fortnet/view/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flappy_fortnet/controller/fortservice.dart';
import 'package:flappy_fortnet/model/utenti.dart';

class ReadScreen<T extends DeserJson> extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  _ReadScreenState<T> createState() => _ReadScreenState<T>();
}

class _ReadScreenState<T extends DeserJson> extends State<ReadScreen<T>> {
  var globalVars = Global();
  String title = "Visualizza $T";

  String selectedFilter = "";
  List<String> filters = [];
  Map<String, String> savedFilters = Map.from(<String, String>{});

  TextEditingController inputController = TextEditingController();

  List<T>? list;
  bool isLoaded = false;
  int statusCode = 500; //default saved as generic error

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
    try {
      list = await Fortservice().getAllT();
      statusCode = 200;

      if (T == Utente) {
        filters = Utente.getFields();
      } else if (T == Post) {
        filters = Post.getFields();
      } else if (T == Like) {
        filters = Like.getFields();
      }
    } catch (e) {
      list = [];
      filters = [];

      try {
        statusCode = int.parse(e.toString());
      } catch (e) {
        statusCode = 500;
      }
    }

    selectedFilter = filters.firstOrNull ?? '';

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _currentRoute = ModalRoute.of(context)?.settings.name;
    // ignore: unused_local_variable
    final currentRoute =
        _currentRoute!.endsWith('/') ? _currentRoute : '$_currentRoute/';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: isLoaded && list != null
          ? (statusCode == 200 || statusCode == 204)
              ? buildReady()
              : ErrorScreen.auto(
                  errorCode: statusCode, header: "Errore $statusCode")
          : buildOnLoading(),
    );
  }

  Widget buildOnLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildReady() {
    final String savedFiltersString = (savedFilters.isEmpty)
        ? "Nessun filtro impostato"
        : "filtri applicati: ${savedFilters.toString()}";

    return Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Row(
              children: [
                Text("Scegli che filtro applicare:"),
              ],
            ),

            const SizedBox(width: 8), //

            Row(
              children: [
                Container(
                  //SELECT
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      onChanged: (String? newFilter) {
                        setState(() {
                          selectedFilter = newFilter!;
                        });
                      },
                      items:
                          filters.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                //TEXTFIELD
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: const InputDecoration(
                      labelText: 'Inserisci il valore del filtro',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                ElevatedButton(
                  //SAVE BTN
                  onPressed: () async {
                    if (inputController.text != "") {
                      if (selectedFilter.startsWith("id") &&
                          int.tryParse(inputController.text) == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Prego inserire un valore numerico sui campi ID"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } else {
                        // if (
                        //   (selectedFilter.startsWith("id") && int.tryParse(inputController.text) != null) ||
                        //   !selectedFilter.startsWith("id")
                        // ) {
                        savedFilters[selectedFilter] = inputController.text;
                        inputController.clear();
                        // Call the async function *before* setState
                        try {
                          List<T> newList =
                              await Fortservice().getT(savedFilters);
                          statusCode = 200;

                          // trigger reload
                          setState(() {
                            list = newList;
                          });
                        } catch (e) {
                          try {
                            statusCode = int.parse(e.toString());
                          } catch (e) {
                            statusCode = 500;
                          }
                        }
                      }
                    }
                  },
                  child: const Text('Salva filtro'),
                ),

                const SizedBox(width: 8), //space

                ElevatedButton(
                  //RESET BTN
                  onPressed: () async {
                    try {
                      List<T> newList = await Fortservice().getAllT();
                      statusCode = 200;

                      // trigger reload
                      setState(() {
                        list = newList;
                        savedFilters.clear();
                      });
                    } catch (e) {
                      try {
                        statusCode = int.parse(e.toString());
                      } catch (e) {
                        statusCode = 500;
                      }
                    }
                  },
                  child: const Text('Reset dei filtri'),
                ),
              ],
            ),

            const SizedBox(height: 8), //space

            Row(
              children: [
                Text(savedFiltersString),
              ],
            ),

            const SizedBox(height: 8), //space

            list!.isNotEmpty // TODOHERE
                ? (list!.length == 1)
                    ? detailedOne()
                    : summarizedList()
                : (savedFilters.isEmpty
                    ? Text("Nessun $T registrato nel DataBase!")
                    : Text("Nessun $T trovato con questi criteri di ricerca!"))
          ],
        ));
  }

  Widget summarizedList() {
    return Expanded(
        child: ListView.builder(
      //list of Ts
      itemCount: list!.length,
      itemBuilder: (context, index) {
        final element = list![index];

        return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 2,
              ),
              onPressed: () async {
                try {
                  Map<String, String> newFilters = (T == Like)
                      ? <String, String>{
                          "id_user": (element as Like).user.id.toString(),
                          "id_post": (element as Like).post.id.toString(),
                        }
                      : <String, String>{
                          filters[0]: element.toJson()[filters[0]].toString()
                        };
                  List<T> newList = await Fortservice().getT(
                      //get specified T
                      newFilters);
                  statusCode = 200;

                  // trigger reload
                  setState(() {
                    list = newList;
                    savedFilters = Map.from(newFilters);
                  });
                } catch (e) {
                  try {
                    statusCode = int.parse(e.toString());
                  } catch (e) {
                    statusCode = 500;
                  }
                }
              },
              child: listTileOf<T>(list![index]),
            ));
      },
    ));
  }

  Widget detailedOne() {
    var jsonObj = list![0].toJson();

    //modify obj if has nested object like DeserJson
    final entries = List<MapEntry<String, dynamic>>.from(jsonObj.entries);
    for (var entry in entries) {
      if (entry.value is DeserJson) {
        var jsonElement = (entry.value as DeserJson).toJson();

        jsonObj.addAll(
          jsonElement.map(
            (key, value) => MapEntry('${entry.key}.$key', value),
          ),
        );

        jsonObj.remove(entry.key);
      }
    }

    return DetailedViewTable(data: jsonObj);
  }
}

ListTile listTileOf<T>(T entry) {
  if (T == Utente) {
    Utente u = entry as Utente;
    return ListTile(
      title: Text(u.username),
      subtitle: Text('ID: ${u.id}'),
    );
  } else if (T == Post) {
    Post p = entry as Post;
    return ListTile(
      title: Text(p.title),
      subtitle: Text('ID: ${p.id}'),
    );
  } else if (T == Like) {
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
