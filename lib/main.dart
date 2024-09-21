import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lista de Tarefas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> tarefas_nao_concluidas = ['1','2','3','4'];
  List<String> tarefas_concluidas = [];
  
  TextEditingController _editingController = TextEditingController();
  String _labelText = 'Digite a nova tarefa';
  int? _editingIndex;

  void _changeList(int i, List<String> l1, List<String> l2) {
    setState(() {
      l2.add(l1[i]);
      l1.removeAt(i);
    });
  }

  void _deleteTarefa(int index, List<String> tarefas) {
    setState(() {
      tarefas.removeAt(index);
    });
  }

  void _addTarefa() {
    setState(() {
      if (_editingController.text.isNotEmpty) {
        if (_editingIndex != null) {
          tarefas_nao_concluidas[_editingIndex!] = _editingController.text;
          _editingIndex = null;
        } else {
          tarefas_nao_concluidas.add(_editingController.text);
        }
        _editingController.clear();
        _labelText = 'Digite a nova tarefa';
      }
    });
  }

  void _reorderTarefa(newIndex, oldIndex, List<String> lista) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = lista.removeAt(oldIndex);
      lista.insert(newIndex, item);
    });
  }

  void _editTarefa(int index, List<String> lista) {
    setState(() {
      _editingController.text = lista[index];
      _labelText = 'Editando a tarefa';
      _editingIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          TextField(
            controller: _editingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: _labelText,
            ),
          ),
          SizedBox(height: 20),
          Text('Tarefas Não Concluídas', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                _reorderTarefa(newIndex, oldIndex, tarefas_nao_concluidas);
              },
              children: [
                for (int index = 0; index < tarefas_nao_concluidas.length; index++)
                  Card(
                    key: ValueKey(index),
                    surfaceTintColor: Colors.red,
                    child: ListTile(
                      title: Text(tarefas_nao_concluidas[index]),
                      leading: IconButton(
                        icon: Icon(Icons.check_box_outline_blank),
                        onPressed: () {
                          _changeList(index, tarefas_nao_concluidas, tarefas_concluidas);
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _editTarefa(index, tarefas_nao_concluidas);
                            }, icon: Icon(Icons.edit)),
                          IconButton(
                            onPressed: () {
                              _deleteTarefa(index, tarefas_nao_concluidas);
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
              ]
            ),
          ),
          Text('Tarefas Concluídas', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                _reorderTarefa(newIndex, oldIndex, tarefas_concluidas);
              },
              children: [
                for (int index = 0; index < tarefas_concluidas.length; index++)
                  Card(
                    key: ValueKey(index),
                    surfaceTintColor: Colors.green,
                    child: ListTile(
                      title: Text(tarefas_concluidas[index]),
                      leading: IconButton(
                        icon: Icon(Icons.check_box),
                        onPressed: () {
                          _changeList(index, tarefas_concluidas, tarefas_nao_concluidas);
                        },
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _deleteTarefa(index, tarefas_concluidas);
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    ),
                  ),
              ]
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTarefa,
        tooltip: 'Adicionar Tarefa',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}