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

  void _completed(int i) {
    setState(() {
      tarefas_concluidas.add(tarefas_nao_concluidas[i]);
      tarefas_nao_concluidas.removeAt(i);
    });
  }

  void _notCompleted(int i) {
    setState(() {
      tarefas_nao_concluidas.add(tarefas_concluidas[i]);
      tarefas_concluidas.removeAt(i);
    });
  }

  void _deleteTarefaNaoConcluida(int i) {
    setState(() {
      tarefas_nao_concluidas.removeAt(i);
    });
  }

  void _deleteTarefaConcluida(int i) {
    setState(() {
      tarefas_concluidas.removeAt(i);
    });
  }

  void _addTarefa() {
    setState(() {
      if (_editingController.text.isNotEmpty) {
        tarefas_nao_concluidas.add(_editingController.text);
        _editingController.clear();
      }
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
              labelText: 'Digite a nova tarefa',
            ),
          ),
          SizedBox(height: 20),
          Text('Tarefas Não Concluídas', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = tarefas_nao_concluidas.removeAt(oldIndex);
                  tarefas_nao_concluidas.insert(newIndex, item);
                });
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
                          _completed(index);
                        },
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _deleteTarefaNaoConcluida(index);
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.red,
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
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = tarefas_concluidas.removeAt(oldIndex);
                  tarefas_concluidas.insert(newIndex, item);
                });
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
                          _notCompleted(index);
                        },
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _deleteTarefaConcluida(index);
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