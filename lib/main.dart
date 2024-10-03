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
  List<String> tarefas_nao_concluidas = ['1', '2', '3', '4'];
  List<String> tarefas_concluidas = [];

  final TextEditingController _editingController = TextEditingController();
  String _labelText = 'Digite a nova tarefa';
  String _alertDialogTitle = 'Adicionar Tarefa';
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

  void _reset() {
    _editingController.clear();
    _labelText = 'Digite a nova tarefa';
    _alertDialogTitle = 'Adicionar Tarefa';
    _editingIndex = null;
  }

  void _addTarefa(List<String> lista) {
    setState(() {
      if (_editingController.text.isNotEmpty) {
        if (_editingIndex != null) {
          lista[_editingIndex!] = _editingController.text;
        } else {
          lista.add(_editingController.text);
        }
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
      _alertDialogTitle = 'Editar Tarefa';
      _editingIndex = index;
    });
  }

  void _mostrarDialogo(BuildContext context, List<String> lista) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            _reset();
            return true;
          },
          child: AlertDialog(
            title: Text(_alertDialogTitle),
            content: TextField(
                controller: _editingController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: _labelText,
                )),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _addTarefa(lista);
                  _reset();
                  Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
              TextButton(
                onPressed: () {
                  _reset();
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _listas({
    String titulo = 'Tarefas',
    required List<String> lista1,
    required List<String> lista2,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: lista1 == tarefas_concluidas
                    ? const Color(0xFF388E3C)
                    : const Color(0xFFD32F2F))),
        Expanded(
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              _reorderTarefa(newIndex, oldIndex, lista1);
            },
            children: [
              for (int index = 0; index < lista1.length; index++)
                Card(
                  key: ValueKey(index),
                  surfaceTintColor:
                      lista1 == tarefas_concluidas ? Colors.green : Colors.red,
                  child: ListTile(
                    title: Text(lista1[index]),
                    leading: IconButton(
                      icon: lista1 == tarefas_concluidas
                          ? const Icon(Icons.check_box)
                          : const Icon(Icons.check_box_outline_blank),
                      onPressed: () {
                        _changeList(index, lista1, lista2);
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _editTarefa(index, lista1);
                            _mostrarDialogo(context, lista1);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteTarefa(index, lista1);
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        title: const Text(
          'Lista de Tarefas',
          style: TextStyle(
            fontSize: 24, // Tamanho da fonte
            fontWeight: FontWeight.bold, // Estilo da fonte
            color: Colors.white, // Cor da fonte
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: _listas(
                  titulo: 'Tarefas Não Concluídas',
                  lista1: tarefas_nao_concluidas,
                  lista2: tarefas_concluidas)),
          Expanded(
              child: _listas(
                  titulo: 'Tarefas Concluídas',
                  lista1: tarefas_concluidas,
                  lista2: tarefas_nao_concluidas)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogo(context, tarefas_nao_concluidas);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
