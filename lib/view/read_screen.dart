import 'package:flappy_fortnet/model/deser_json.dart';
import 'package:flappy_fortnet/model/likes.dart';
import 'package:flappy_fortnet/model/posts.dart';
import 'package:flutter/material.dart';
import 'package:flappy_fortnet/controller/fortservice.dart';
import 'package:flappy_fortnet/model/utenti.dart';

class ReadScreen<T extends DeserJson> extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  _ReadScreenState<T> createState() => _ReadScreenState<T>();
}

class _ReadScreenState<T extends DeserJson> extends State<ReadScreen<T>> {
  String title = "Visualizza $T";

  String selectedFilter = "";
  List<String> filters = [];
  Map<String, String> savedFilters = Map.from(<String, String>{});

  TextEditingController inputController = TextEditingController();

  List<T>? list;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadT();
  }

  Future<void> loadT() async {
    if(T == Utente) {
      title = "Visualizza Utenti";
      filters = Utente.getFields();
      list = (await Fortservice().getAllUsers())!.cast<T>();

    } else if (T == Post) {
      title = "Visualizza Posts";
      filters = Post.getFields();
      list = (await Fortservice().getAllPosts())!.cast<T>();

    } else if (T == Like) {
      title = "Visualizza Likes";
      filters = Like.getFields();
      list = (await Fortservice().getAllLikes())!.cast<T>();

    } else {
      title = "Errore";
      list = [];

    }

    selectedFilter = filters.firstOrNull ?? '';

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String savedFilters_str = (savedFilters.isEmpty) ?
      "Nessun filtro impostato" :  "filtri applicati: ${savedFilters.toString()}";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: isLoaded && list != null ?
      Column(
        children: [
          const Row(
            children: [
              const Text("Scegli che filtro applicare:"),
            ],
          ),

          const SizedBox(width: 8),//

          Row(
            children: [
              Container(//SELECT
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
                    items: filters.map<DropdownMenuItem<String>>((String value) {
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
              ElevatedButton(//SAVE BTN
                onPressed: () async {
                  if (inputController.text != "") {
                    savedFilters[selectedFilter] = inputController.text;
                    inputController.clear();

                    // Call the async function *before* setState
                    List<T> newList = await Fortservice().getT(savedFilters);

                    // trigger reload
                    setState(() {
                      list = newList;
                    });
                  }
                },
                child: const Text('Salva filtro'),
              ),

              const SizedBox(width: 8),//space

              ElevatedButton(//RESET BTN
                onPressed: () async {
                  List<T> newList = await Fortservice().getAllT();

                  // trigger reload
                  setState(() {
                    list = newList;
                    savedFilters.clear();
                  });
                },
                child: const Text('Reset dei filtri'),
              ),
            ],
          ),

          const SizedBox(height: 8),//space

          Row(
            children: [
              Text(savedFilters_str),
            ],
          ),

          const SizedBox(height: 8),//space
          
          list!.isNotEmpty ?
          Expanded(child: ListView.builder(//list of Ts
            itemCount: list!.length,
            itemBuilder: (context, index) {
              final element = list![index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 2,
                  ),
                  onPressed: () async {
                  List<T> newList = await Fortservice().getT(//get specified T
                    Map.from(<String, String>{ filters[0]: element.toJson()[filters[0]].toString() })
                  );
                  
                  //todo: show specific of T


                  // trigger reload
                  setState(() {
                    list = newList;
                    savedFilters.clear();
                  });
                },
                  child: listTileOf<T>(list![index]),
                )
              );
            },
          ))
          :
          (
            savedFilters.isEmpty ?
              Text("Nessun $T registrato nel DataBase!")
              :
              Text("Nessun $T trovato con questi criteri di ricerca!")
          )
        ],
      )
      :
      const Center(child: CircularProgressIndicator()),
    );
  }
}

ListTile listTileOf<T>(T entry) {
  if(T == Utente) {
    Utente u = entry as Utente;
    return ListTile(
      title: Text(u.username),
      subtitle: Text('ID: ${u.id}'),
    );

  } else if(T == Post) {
  Post p = entry as Post;
    return ListTile(
      title: Text(p.title),
      subtitle: Text('ID: ${p.id}'),
    );

  } else if(T == Like) {
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

/*
Expanded(child: ListView.builder(//list of Ts
            itemCount: list!.length,
            itemBuilder: (context, index) {
              return listTileOf<T>(list![index]);
            },
          ))
*/